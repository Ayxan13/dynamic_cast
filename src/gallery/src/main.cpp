#include <QtCore/QCommandLineParser>
#include <QtCore/QTimer>
#include <QtGui/QFontDatabase>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtQuick/QQuickWindow>

#include <QtQml/QQmlExtensionPlugin>
Q_IMPORT_QML_PLUGIN(DynamicCastPlugin)

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);

    QCommandLineParser parser;
    parser.addHelpOption();
    QCommandLineOption screenshotOpt(
        "screenshot",
        "Render the gallery, save a screenshot to <path>, then exit.",
        "path");
    QCommandLineOption componentOpt(
        "component",
        "Pre-select a component by name (e.g. MiniPlayer).",
        "name");
    parser.addOption(screenshotOpt);
    parser.addOption(componentOpt);
    parser.process(app);

    QFontDatabase::addApplicationFont(
        ":/qt/qml/DynamicCast/assets/fonts/MaterialIcons-Regular.ttf");

    QQmlApplicationEngine engine;
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
                if (!window) return;
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

    // Expose the initial component name as a context property so Gallery.qml
    // can read it synchronously during construction (before any bindings fire).
    const QString initialComponent =
        parser.isSet(componentOpt) ? parser.value(componentOpt) : QString{};
    engine.rootContext()->setContextProperty("_initialComponent", initialComponent);

    engine.loadFromModule("DynamicCastGallery", "GalleryMain");

    return QGuiApplication::exec();
}
