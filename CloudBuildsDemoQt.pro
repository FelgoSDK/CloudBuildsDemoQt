QT += quick
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


android {
  ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
  OTHER_FILES += android/AndroidManifest.xml  android/build.gradle

  # If the app requires OpenSSL, additional libraries are required. Uncomment ANDROID_EXTRA_LIBS lines in this case.
  # More information: https://github.com/ekke/android-openssl-qt
  # Both libraries are available and added at Felgo Cloud Builds and the _MANAGED flags are set
  isEmpty(ANDROID_LIBCRYPTO_MANAGED) {
    # ANDROID_EXTRA_LIBS += $$_PRO_FILE_PWD_/android-openssl-qt/prebuilt/armeabi-v7a/libcrypto.so
  }
  isEmpty(ANDROID_LIBSSL_MANAGED) {
    # ANDROID_EXTRA_LIBS += $$_PRO_FILE_PWD_/android-openssl-qt/prebuilt/armeabi-v7a/libssl.so
  }
}

ios {
  QMAKE_INFO_PLIST = ios/Project-Info.plist
  OTHER_FILES += $$QMAKE_INFO_PLIST

  # Set ID - fix for Qt = 5.11.1 - https://bugreports.qt.io/browse/QTBUG-70072
  equals(QT_MAJOR_VERSION, 5):equals(QT_MINOR_VERSION, 11):equals(QT_PATCH_VERSION, 1) {
    load(default_post.prf)
  }
  xcode_product_bundle_identifier_setting.value = "com.yourcompany.cloudbuildsdemoqt"

  # Set ID - Qt >= 5.12
  QMAKE_TARGET_BUNDLE_PREFIX = "com.yourcompany"
  QMAKE_BUNDLE = "cloudbuildsdemoqt"

  !equals(TEMPLATE, lib):exists( $$_PRO_FILE_PWD_/ios/Assets.xcassets ) {
    QMAKE_ASSET_CATALOGS += $$_PRO_FILE_PWD_/ios/Assets.xcassets
    QMAKE_ASSET_CATALOGS_APP_ICON = AppIcon
    export(QMAKE_ASSET_CATALOGS)
    export(QMAKE_ASSET_CATALOGS_APP_ICON)

    # Use new storyboard launch screen
    exists($$_PRO_FILE_PWD_/ios/Launch Screen.storyboard) {
      QMAKE_LAUNCH_SCREEN = "ios/Launch Screen.storyboard"
      launch_screen_bundle.files = $$QMAKE_LAUNCH_SCREEN
      QMAKE_BUNDLE_DATA += launch_screen_bundle
    }

    # Use old launch images
    exists($$_PRO_FILE_PWD_/ios/Assets.xcassets/LaunchImage.launchimage) {
      QMAKE_ASSET_CATALOGS_LAUNCH_IMAGE = LaunchImage
      export(QMAKE_ASSET_CATALOGS_LAUNCH_IMAGE)
    }
  }

  export(QMAKE_BUNDLE_DATA)
}

