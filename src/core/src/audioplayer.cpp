#include "dccore/audioplayer.hpp"

dc::AudioPlayer::AudioPlayer(QObject* parent)
    : QObject(parent)
{
    m_player.setAudioOutput(&m_audioOutput);
    m_audioOutput.setVolume(1.0f);

    connect(&m_player, &QMediaPlayer::playbackStateChanged, this, [this](QMediaPlayer::PlaybackState state) {
        emit playingChanged();
        // Pause/stop always clears buffering — user deliberately left playing state.
        if (state != QMediaPlayer::PlayingState)
            setBuffering(false);
    });

    connect(&m_player, &QMediaPlayer::positionChanged, this, [this](qint64) {
        emit positionChanged();
        // Each seek increments m_pendingSeeks. The corresponding positionChanged
        // (fired by the backend when the seek lands) consumes one credit. Once
        // the counter reaches 0 the next positionChanged is from real playback,
        // which means audio is actually flowing — reliable signal to end buffering.
        if (m_pendingSeeks > 0) {
            --m_pendingSeeks;
        } else if (m_buffering && m_player.playbackState() == QMediaPlayer::PlayingState) {
            setBuffering(false);
        }
    });

    connect(&m_player, &QMediaPlayer::durationChanged, this, &AudioPlayer::durationChanged);

    connect(&m_player, &QMediaPlayer::mediaStatusChanged, this, [this](QMediaPlayer::MediaStatus status) {
        switch (status) {
        case QMediaPlayer::LoadingMedia:
        case QMediaPlayer::BufferingMedia:
        case QMediaPlayer::StalledMedia:
            if (m_player.playbackState() == QMediaPlayer::PlayingState)
                setBuffering(true);
            break;
        default:
            setBuffering(false);
            break;
        }
    });
}

bool dc::AudioPlayer::playing() const
{
    return m_player.playbackState() == QMediaPlayer::PlayingState;
}

qreal dc::AudioPlayer::position() const
{
    const qint64 dur = m_player.duration();
    if (dur <= 0)
        return 0.0;
    return static_cast<qreal>(m_player.position()) / static_cast<qreal>(dur);
}

qint64 dc::AudioPlayer::duration() const
{
    return m_player.duration();
}

qint64 dc::AudioPlayer::currentTime() const
{
    return m_player.position();
}

void dc::AudioPlayer::playEpisode(const QString& audioUrl,
                                   const QString& title,
                                   const QString& podcastName,
                                   const QUrl& artworkUrl)
{
    m_pendingSeeks = 0;
    m_episodeUrl = audioUrl;
    m_title = title;
    m_podcastName = podcastName;
    m_artworkUrl = artworkUrl;
    emit metaChanged();

    m_player.setSource(QUrl(audioUrl));
    m_player.play();

    // Show the spinner immediately. The FFmpeg backend often doesn't emit
    // LoadingMedia/BufferingMedia until well into the fetch, so waiting for
    // mediaStatusChanged leaves the UI showing a plain play icon during the wait.
    setBuffering(true);
}

void dc::AudioPlayer::togglePlayPause()
{
    if (m_player.playbackState() == QMediaPlayer::PlayingState) {
        m_player.pause();
        // Clear immediately — playbackStateChanged may not fire reliably while
        // the backend is in a stalled state, which would leave the spinner stuck.
        setBuffering(false);
    } else {
        m_player.play();
    }
}

void dc::AudioPlayer::skipForward(int seconds)
{
    ++m_pendingSeeks;
    m_player.setPosition(m_player.position() + static_cast<qint64>(seconds) * 1000LL);
}

void dc::AudioPlayer::seek(qreal position)
{
    const qint64 dur = m_player.duration();
    if (dur > 0) {
        ++m_pendingSeeks;
        m_player.setPosition(static_cast<qint64>(position * static_cast<qreal>(dur)));
    }
}

void dc::AudioPlayer::setBuffering(bool value)
{
    if (m_buffering != value) {
        m_buffering = value;
        emit bufferingChanged();
    }
}
