#pragma once

#include "dcbackend/feedprovider.hpp"
#include <QCoro/QCoroQmlTask>
#include <QCoro/QCoroTask>
#include <QObject>
#include <QVariantList>
#include <memory>

namespace dc {

struct EpisodeResult {
    Q_GADGET
    Q_PROPERTY(QString title MEMBER title)
    Q_PROPERTY(QString pubDate MEMBER pubDate)
    Q_PROPERTY(QString duration MEMBER duration)
    Q_PROPERTY(QString audioUrl MEMBER audioUrl)
    Q_PROPERTY(int episodeNumber MEMBER episodeNumber)
public:
    QString title;
    QString pubDate;
    QString duration;
    QString audioUrl;
    int episodeNumber = -1;
};

struct FeedResult {
    Q_GADGET
    Q_PROPERTY(QString title MEMBER title)
    Q_PROPERTY(QString hosts MEMBER hosts)
    Q_PROPERTY(QString description MEMBER description)
    Q_PROPERTY(QString imageUrl MEMBER imageUrl)
    Q_PROPERTY(QString link MEMBER link)
    Q_PROPERTY(QString primaryGenre MEMBER primaryGenre)
    Q_PROPERTY(QVariantList episodes MEMBER episodes)
public:
    QString title;
    QString hosts;
    QString description;
    QString imageUrl;
    QString link;
    QString primaryGenre;
    QVariantList episodes;
};

class FeedController final : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

public:
    explicit FeedController(std::unique_ptr<IFeedProvider> provider,
        QObject* parent = nullptr);

    bool loading() const { return m_loading; }

    Q_INVOKABLE QCoro::QmlTask fetch(const QString& url);

signals:
    void loadingChanged();
    void fetchFailed(QString error);

private:
    void setLoading(bool newValue);
    QCoro::Task<FeedResult> doFetch(QString url);

    std::unique_ptr<IFeedProvider> m_provider;
    bool m_loading = false;
};

} // namespace dc

Q_DECLARE_METATYPE(dc::EpisodeResult)
Q_DECLARE_METATYPE(dc::FeedResult)
