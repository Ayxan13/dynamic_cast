#pragma once

#include "dcbackend/searchprovider.hpp"
#include <QCoro/QCoroTask>
#include <QObject>
#include <QVariantList>
#include <memory>

namespace dc {

struct PodcastResult {
    Q_GADGET
    Q_PROPERTY(QString podcastName MEMBER podcastName)
    Q_PROPERTY(QString author MEMBER author)
    Q_PROPERTY(QString artworkUrl MEMBER artworkUrl)
public:
    QString podcastName;
    QString author;
    QString artworkUrl;
};

class SearchController final : public QObject {
    Q_OBJECT
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

public:
    explicit SearchController(std::unique_ptr<ISearchProvider> provider,
        QObject* parent = nullptr);

    bool loading() const { return m_loading; }

    Q_INVOKABLE void search(const QString& term);

signals:
    void loadingChanged();
    void resultsReady(QList<dc::PodcastResult> results);
    void searchFailed(QString error);

private:
    void setLoading(bool newValue);
    QCoro::Task<void> doSearch(QString term);

    std::unique_ptr<ISearchProvider> m_provider;
    bool m_loading = false;
};

} // namespace dc

Q_DECLARE_METATYPE(dc::PodcastResult)
Q_DECLARE_METATYPE(QList<dc::PodcastResult>)
