#pragma once

#include <QAudioOutput>
#include <QMediaPlayer>
#include <QObject>
#include <QString>
#include <QUrl>

namespace dc {

class AudioPlayer final : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool playing READ playing NOTIFY playingChanged)
    Q_PROPERTY(bool hasMedia READ hasMedia NOTIFY metaChanged)
    Q_PROPERTY(QString title READ title NOTIFY metaChanged)
    Q_PROPERTY(QString podcastName READ podcastName NOTIFY metaChanged)
    Q_PROPERTY(QUrl artworkUrl READ artworkUrl NOTIFY metaChanged)
    Q_PROPERTY(QString episodeUrl READ episodeUrl NOTIFY metaChanged)
    Q_PROPERTY(qreal position READ position NOTIFY positionChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(qint64 currentTime READ currentTime NOTIFY positionChanged)
    Q_PROPERTY(bool buffering READ buffering NOTIFY bufferingChanged)

public:
    explicit AudioPlayer(QObject* parent = nullptr);

    bool playing() const;
    bool buffering() const { return m_buffering; }
    bool hasMedia() const { return !m_episodeUrl.isEmpty(); }
    QString title() const { return m_title; }
    QString podcastName() const { return m_podcastName; }
    QUrl artworkUrl() const { return m_artworkUrl; }
    QString episodeUrl() const { return m_episodeUrl; }
    qreal position() const;
    qint64 duration() const;
    qint64 currentTime() const;

    Q_INVOKABLE void playEpisode(const QString& audioUrl,
                                  const QString& title,
                                  const QString& podcastName,
                                  const QUrl& artworkUrl);
    Q_INVOKABLE void togglePlayPause();
    Q_INVOKABLE void skipForward(int seconds = 30);
    Q_INVOKABLE void seek(qreal position);

signals:
    void playingChanged();
    void metaChanged();
    void positionChanged();
    void durationChanged();
    void bufferingChanged();

private:
    void setBuffering(bool value);

    QMediaPlayer m_player;
    QAudioOutput m_audioOutput;
    QString m_title;
    QString m_podcastName;
    QUrl m_artworkUrl;
    QString m_episodeUrl;
    bool m_buffering = false;
    int m_pendingSeeks = 0; // seek-induced positionChanged events to skip before using position as a buffering-clear signal
};

} // namespace dc
