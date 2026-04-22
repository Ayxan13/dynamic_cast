#include "dcbackend/feedcontroller.hpp"
#include "dcbackend/feedprovider.hpp"
#include "dcbackend/searchcontroller.hpp"
#include "dcbackend/searchprovider.hpp"
#include <QCoro/QCoroQml>
#include <QCoro/QCoroTask>
#include <QCoro/QCoroTimer>

#include <QtCore/QEventLoop>
#include <QtCore/QTimer>
#include <QtGui/QFontDatabase>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtQuick/QQuickWindow>

#include <QtQml/QQmlExtensionPlugin>
Q_IMPORT_QML_PLUGIN(DynamicCastPlugin)

using Qt::StringLiterals::operator""_s;

// ── Dummy provider (no network calls) ────────────────────────────────────────

namespace {
struct DummySearchProvider final : dc::ISearchProvider {
    QCoro::Task<dc::Expected<QVector<dc::PodcastSearchResult>, Error>> search(
        const QString&, int) const override
    {
        co_return dc::Expected<QVector<dc::PodcastSearchResult>, Error> {
            QVector<dc::PodcastSearchResult> {}
        };
    }
};

struct DummyFeedProvider final : dc::IFeedProvider {
    QCoro::Task<dc::Expected<dc::PodcastFeed, dc::Error>> fetch(const QUrl& /*url*/) const override
    {
        co_return dc::Expected<dc::PodcastFeed, dc::Error> { dc::PodcastFeed {} };
    }
};
} // namespace

// ── Message capture ───────────────────────────────────────────────────────────

static QStringList g_errors;

static void messageHandler(QtMsgType type, const QMessageLogContext& ctx, const QString& msg)
{
    // Always print to stderr so CI logs show context
    const char* severity = "";
    switch (type) {
    case QtWarningMsg:  severity = "WARNING"; break;
    case QtCriticalMsg: severity = "CRITICAL"; break;
    case QtFatalMsg:    severity = "FATAL";    break;
    default: return; // ignore debug/info
    }
    fprintf(stderr, "[%s] %s\n", severity, qPrintable(msg));

    // QML component load errors arrive as warnings; catch them by looking for
    // the standard QML error patterns (file URL, "qml:", ReferenceError, etc.)
    const bool isQmlError = msg.contains(u"qml:"_s, Qt::CaseInsensitive)
        || msg.contains(u"qrc:/"_s, Qt::CaseInsensitive)
        || msg.contains(u"file://"_s, Qt::CaseInsensitive);
    if (type >= QtCriticalMsg || isQmlError) {
        g_errors.append(msg);
    }
    (void)ctx;
}

// ── Helpers ───────────────────────────────────────────────────────────────────

static void pumpEvents(int ms = 300)
{
    QEventLoop loop;
    QTimer::singleShot(ms, &loop, &QEventLoop::quit);
    loop.exec();
}

// ── Main ──────────────────────────────────────────────────────────────────────

int main(int argc, char* argv[])
{
    // Force offscreen rendering — no display required
    qputenv("QT_QPA_PLATFORM", "offscreen");

    QGuiApplication app(argc, argv);
    QCoro::Qml::registerTypes();

    QFontDatabase::addApplicationFont(
        u":/qt/qml/DynamicCast/assets/fonts/MaterialIcons-Regular.ttf"_s);

    // Install after app construction to skip platform-init noise
    qInstallMessageHandler(messageHandler);

    dc::SearchController searchController(std::make_unique<DummySearchProvider>());
    dc::FeedController feedController(std::make_unique<DummyFeedProvider>());

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(u"searchController"_s, &searchController);
    engine.rootContext()->setContextProperty(u"feedController"_s, &feedController);
    engine.rootContext()->setContextProperty(u"_initialComponent"_s, QString {});

    bool creationFailed = false;
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, [&] { creationFailed = true; },
        Qt::QueuedConnection);

    engine.loadFromModule(u"DynamicCastGallery"_s, u"GalleryMain"_s);
    pumpEvents(200);

    if (creationFailed || !g_errors.isEmpty()) {
        fprintf(stderr, "FAIL: errors during initial load\n");
        return 1;
    }

    // Locate the Gallery item by its unique custom "components" property
    QObject* gallery = nullptr;
    if (!engine.rootObjects().isEmpty()) {
        for (auto* obj : engine.rootObjects().first()->findChildren<QObject*>()) {
            const QVariant v = obj->property("components");
            if (v.isValid() && !v.value<QVariantList>().isEmpty()) {
                gallery = obj;
                break;
            }
        }
    }

    if (!gallery) {
        fprintf(stderr, "FAIL: could not locate Gallery object in scene\n");
        return 1;
    }

    const QVariantList components = gallery->property("components").value<QVariantList>();
    const int count = components.size();
    fprintf(stdout, "Iterating %d gallery components...\n", count);

    for (int i = 0; i < count; ++i) {
        const QString name = components[i].toMap().value(u"name"_s).toString();
        fprintf(stdout, "  [%d/%d] %s\n", i + 1, count, qPrintable(name));

        gallery->setProperty("selectedIndex", i);
        pumpEvents(300);

        if (!g_errors.isEmpty()) {
            fprintf(stderr, "FAIL: error(s) logged while loading '%s'\n", qPrintable(name));
            for (const auto& e : std::as_const(g_errors))
                fprintf(stderr, "  %s\n", qPrintable(e));
            return 1;
        }
    }

    fprintf(stdout, "PASS: all %d components loaded without errors\n", count);
    return 0;
}
