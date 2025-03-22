import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.infoex"

    compileSdk = 35 // ✅ 直接 Hardcode
    ndkVersion = "27.0.12077973" // ✅ 直接 Hardcode NDK 版本

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.infoex.asdCare"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val keystorePropertiesFile = file("key.properties") // ✅ 這樣就可以了
            if (keystorePropertiesFile.exists()) {
                val keystoreProperties = Properties().apply {
                    load(FileInputStream(keystorePropertiesFile))
                }
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            } else {
                println("⚠️ key.properties not found, using debug signingConfig!")
            }
        }
    }    

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug") // ✅ 保留 Debug 簽名
        }
        release {
            isMinifyEnabled = true // ✅ 啟用代碼壓縮
            isShrinkResources = true // ✅ 移除未使用的資源
            signingConfig = signingConfigs.getByName("release") // ✅ 使用 release 簽名

            // ✅ 這行會讓 Gradle 產生 native debug 符號
            ndk {
                debugSymbolLevel = "FULL"
            }            
        }
    }
}

flutter {
    source = "../.."
}
