#include "dcbackend/feedcontroller.hpp"
#include "dcbackend/feedprovider.hpp"
#include "dcbackend/searchcontroller.hpp"
#include "dcbackend/searchprovider.hpp"
#include <QCoro/QCoroQml>
#include <QCoro/QCoroTask>
#include <QCoro/QCoroTimer>

#include <QtCore/QCommandLineParser>
#include <QtCore/QTimer>
#include <QtGui/QFontDatabase>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtQuick/QQuickWindow>

#include <QtQml/QQmlExtensionPlugin>
Q_IMPORT_QML_PLUGIN(DynamicCastPlugin)

using Qt::StringLiterals::operator""_s;

namespace {

struct DummySearchProvider final : dc::ISearchProvider {
    QCoro::Task<dc::Expected<QVector<dc::PodcastSearchResult>, Error>> search(
        const QString& /*term*/, int /*limit*/) const override
    {
        // Simulate a short network delay
        co_await QCoro::sleepFor(std::chrono::milliseconds(600));

        using R = dc::PodcastSearchResult;
        QVector<dc::PodcastSearchResult> results {
            R { .title = u"Crime Junkie"_s, .hosts = u"audiochuck"_s, .id = 1 },
            R { .title = u"Serial"_s, .hosts = u"This American Life"_s, .id = 2 },
            R { .title = u"Stuff You Should Know"_s, .hosts = u"iHeart Podcasts"_s, .id = 3 },
            R { .title = u"The Daily"_s, .hosts = u"The New York Times"_s, .id = 4 },
            R { .title = u"Hardcore History"_s, .hosts = u"Dan Carlin"_s, .id = 5 },
        };
        co_return dc::Expected<QVector<dc::PodcastSearchResult>, Error> { std::move(results) };
    }
};

struct DummyFeedProvider final : dc::IFeedProvider {
    QCoro::Task<dc::Expected<dc::PodcastFeed, dc::Error>> fetch(const QUrl& /*url*/) const override
    {
        co_return dc::Expected<dc::PodcastFeed, dc::Error> { dc::PodcastFeed {} };
    }
};

} // namespace

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    QCoro::Qml::registerTypes();

    QCommandLineParser parser;
    parser.addHelpOption();
    QCommandLineOption screenshotOpt(
        u"screenshot"_s,
        u"Render the gallery, save a screenshot to <path>, then exit."_s,
        u"path"_s);
    QCommandLineOption componentOpt(
        u"component"_s,
        u"Pre-select a component by name (e.g. MiniPlayer)."_s,
        u"name"_s);
    parser.addOption(screenshotOpt);
    parser.addOption(componentOpt);
    parser.process(app);

    QFontDatabase::addApplicationFont(
        u":/qt/qml/DynamicCast/assets/fonts/MaterialIcons-Regular.ttf"_s);

    dc::SearchController searchController(std::make_unique<DummySearchProvider>());
    dc::FeedController feedController(std::make_unique<DummyFeedProvider>());

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(u"searchController"_s, &searchController);
    engine.rootContext()->setContextProperty(u"feedController"_s, &feedController);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    if (parser.isSet(screenshotOpt)) {
        const QString path = parser.value(screenshotOpt);
        QObject::connect(
            &engine,
            &QQmlApplicationEngine::objectCreated,
            &app,
            [path](QObject* obj, const QUrl&) {
                auto* window = qobject_cast<QQuickWindow*>(obj);
                if (!window) {
                    return;
                }
                // Wait two frames so the scene is fully painted before grabbing
                QTimer::singleShot(300, [window, path]() {
                    // grabWindow() returns BGRA data on some backends but
                    // labels it as ARGB; rgbSwapped() fixes the channel order
                    // so the saved PNG has correct colours.
                    const QImage img = window->grabWindow().rgbSwapped();
                    if (!img.save(path)) {
                        qWarning("gallery: failed to save screenshot to %s",
                            qPrintable(path));
                        QCoreApplication::exit(1);
                    } else {
                        qInfo("gallery: screenshot saved to %s", qPrintable(path));
                        QCoreApplication::quit();
                    }
                });
            },
            Qt::QueuedConnection);
    }

    const QString initialComponent = parser.isSet(componentOpt) ? parser.value(componentOpt) : QString { };
    engine.rootContext()->setContextProperty(u"_initialComponent"_s, initialComponent);

    engine.loadFromModule(u"DynamicCastGallery"_s, u"GalleryMain"_s);

    return QGuiApplication::exec();
}
