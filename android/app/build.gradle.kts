// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.natupedia"
    compileSdk = flutter.compileSdkVersion
    ndkVersion  = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.natupedia"
        minSdk        = flutter.minSdkVersion
        targetSdk     = flutter.targetSdkVersion
        versionCode   = flutter.versionCode
        versionName   = flutter.versionName
    }

    compileOptions {
        sourceCompatibility        = JavaVersion.VERSION_1_8
        targetCompatibility        = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    // Deshabilita la compresión de PNGs en AAPT2
    aaptOptions {
        additionalParameters += listOf("-0", "png")
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            signingConfig     = signingConfigs.getByName("debug")
            isMinifyEnabled   = false
            isShrinkResources = false
        }
    }
}

dependencies {
    // Para desugar APIs de Java 8+
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}
