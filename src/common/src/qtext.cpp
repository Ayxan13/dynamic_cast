#include "dccommon/qtext.hpp"
#include <QtCore/QObject>

void dc::DeleteLater::operator()(QObject* p) {
    if (p != nullptr) {
        p->deleteLater();
    }
}