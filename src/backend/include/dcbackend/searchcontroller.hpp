#pragma once

#include "dcbackend/searchprovider.hpp"
#include <QCoro/QCoroQmlTask>
#include <QCoro/QCoroTask>
#include <QObject>
#include <memory>

namespace dc {

struct PodcastResult {
    Q_GADGET
    Q_PROPERTY(QString podcastName MEMBER podcastName)
    Q_PROPERTY(QString author MEMBER author)
    Q_PROPERTY(QString artworkUrl MEMBER artworkUrl)
    Q_PROPERTY(QString rssUrl MEMBER rssUrl)
public:
    QString podcastName;
    QString author;
    QString artworkUrl;
    QString rssUrl;
};

class SearchController final : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

public:
    explicit SearchController(std::unique_ptr<ISearchProvider> provider,
        QObject* parent = nullptr);

    bool loading() const { return m_loading; }

    Q_INVOKABLE QCoro::QmlTask search(const QString& term);

signals:
    void loadingChanged();
    void searchFailed(QString error);

private:
    void setLoading(bool newValue);
    QCoro::Task<QList<PodcastResult>> doSearch(QString term);

    std::unique_ptr<ISearchProvider> m_provider;
    bool m_loading = false;
};

} // namespace dc

Q_DECLARE_METATYPE(dc::PodcastResult)
