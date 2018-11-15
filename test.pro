#############################################################################
#
# test.pro
#

TARGET = test
TEMPLATE = app

QT += core

CONFIG += console
CONFIG -= app_bundle

#############################################
# use C++ 17

CONFIG += c++17 

gcc {
	QMAKE_CXXFLAGS += -std=c++17
}
win32-msvc* {
	QMAKE_CXXFLAGS += /std:c++17
}

DEFINES += CRL_USE_QT
DEFINES += CRL_FORCE_QT
DEFINES += CRL_USE_COMMON_LIST

#############################################
# main source code of crl

CRL_ROOT=src/

INCLUDEPATH += \
$${CRL_ROOT}

HEADERS += \
$${CRL_ROOT}crl/crl.h \
$${CRL_ROOT}crl/crl_async.h \
$${CRL_ROOT}crl/crl_object_on_queue.h \
$${CRL_ROOT}crl/crl_on_main.h \
$${CRL_ROOT}crl/crl_queue.h \
$${CRL_ROOT}crl/crl_semaphore.h \

HEADERS += \
$${CRL_ROOT}crl/common/crl_common_config.h \
$${CRL_ROOT}crl/common/crl_common_list.h \
$${CRL_ROOT}crl/common/crl_common_on_main.h \
$${CRL_ROOT}crl/common/crl_common_queue.h \
$${CRL_ROOT}crl/common/crl_common_sync.h \
$${CRL_ROOT}crl/common/crl_common_utils.h

HEADERS += \
$${CRL_ROOT}crl/dispatch/crl_dispatch_async.h \
$${CRL_ROOT}crl/dispatch/crl_dispatch_on_main.h \
$${CRL_ROOT}crl/dispatch/crl_dispatch_queue.h \
$${CRL_ROOT}crl/dispatch/crl_dispatch_semaphore.h 

HEADERS += \
$${CRL_ROOT}crl/qt/crl_qt_async.h \
$${CRL_ROOT}crl/qt/crl_qt_semaphore.h

# win32:HEADERS += \
# src/crl/winapi/crl_winapi_async.h \
# src/crl/winapi/crl_winapi_dll.h \
# src/crl/winapi/crl_winapi_list.h \
# src/crl/winapi/crl_winapi_semaphore.h

SOURCES += \
$${CRL_ROOT}crl/common/crl_common_list.cpp \
$${CRL_ROOT}crl/common/crl_common_on_main.cpp \
$${CRL_ROOT}crl/common/crl_common_queue.cpp

SOURCES += \
$${CRL_ROOT}crl/dispatch/crl_dispatch_async.cpp \
$${CRL_ROOT}crl/dispatch/crl_dispatch_queue.cpp \
$${CRL_ROOT}crl/dispatch/crl_dispatch_semaphore.cpp

SOURCES += \
$${CRL_ROOT}crl/qt/crl_qt_async.cpp \
$${CRL_ROOT}crl/qt/crl_qt_semaphore.cpp

# win32:SOURCES += \
# src/crl/winapi/crl_winapi_async.cpp \
# src/crl/winapi/crl_winapi_list.cpp \
# src/crl/winapi/crl_winapi_semaphore.cpp

#############################################
# test code

SOURCES += \
src/test.cpp


