#include "dcbackend/networkprovider.hpp"
#include "dcbackend/searchcontroller.hpp"
#include "dcbackend/searchprovider.hpp"

#include <QtGui/QFontDatabase>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>

#include <QtQml/QQmlExtensionPlugin>
Q_IMPORT_QML_PLUGIN(DynamicCastPlugin)

using Qt::StringLiterals::operator""_s;

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    QFontDatabase::addApplicationFont(
        u":/qt/qml/DynamicCast/assets/fonts/MaterialIcons-Regular.ttf"_s);

    std::shared_ptr<dc::INetworkProvider> network = dc::createNetworkProvider();
    dc::SearchController searchController(dc::createSearchProvider(network));

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(u"searchController"_s, &searchController);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule(u"DynamicCast"_s, u"Main"_s);

    return QGuiApplication::exec();
}
