#include "dcbackend/feedcontroller.hpp"
#include "dcbackend/feedparser.hpp"
#include "dcbackend/feedprovider.hpp"
#include "dcbackend/networkprovider.hpp"
#include "dcbackend/searchcontroller.hpp"
#include "dcbackend/searchprovider.hpp"

#include <QCoro/QCoroQml>
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
    QCoro::Qml::registerTypes();
    QFontDatabase::addApplicationFont(
        u":/qt/qml/DynamicCast/assets/fonts/MaterialIcons-Regular.ttf"_s);

    std::shared_ptr<dc::INetworkProvider> network = dc::createNetworkProvider();
    dc::SearchController searchController(dc::createSearchProvider(network));
    dc::FeedController feedController(dc::createFeedProvider(dc::createFeedParser(), network));

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(u"searchController"_s, &searchController);
    engine.rootContext()->setContextProperty(u"feedController"_s, &feedController);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule(u"DynamicCast"_s, u"Main"_s);

    return QGuiApplication::exec();
}
