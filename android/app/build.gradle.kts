plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle 插件必须在 Android 和 Kotlin 插件之后应用
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.untitled"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: 替换为你自己的 Application ID
        applicationId = "com.example.untitled"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: 添加 release 签名配置
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}