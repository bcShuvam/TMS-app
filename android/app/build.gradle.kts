plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.task_management_system"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // ← NDK version updated

    compileOptions {
        isCoreLibraryDesugaringEnabled = true // ← Desugaring enabled
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.task_management_system"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Add this line to enable desugaring support
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}