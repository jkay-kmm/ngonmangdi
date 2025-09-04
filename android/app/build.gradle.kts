plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    // id("com.google.gms.google-services")  // Tạm tắt
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ngonmangdi.app"
    compileSdk = 35  // Cập nhật lên Android 15 theo yêu cầu Play Store mới nhất
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ngonmangdi.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 21  // Đặt minSdk cụ thể thay vì dùng flutter.minSdkVersion
        targetSdk = 35  // Cập nhật lên Android 15 theo yêu cầu Play Store mới nhất
        versionCode = 7
        versionName = "1.0.0"
    }

    signingConfigs {
        create("release") {
            storeFile = file("D:/fontend/Document/App/ngonmangdi/my-release-key.jks")
            storePassword = "1572003"
            keyAlias = "my-key-alias"
            keyPassword = "1572003"
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false      // Tắt code shrinking
            isShrinkResources = false    // Tắt resource shrinking
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     "proguard-rules.pro"
            // )
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    // Xóa hết Play Core để tránh xung đột
    // implementation("com.google.android.play:app-update:2.1.0")
    // implementation("com.google.android.play:feature-delivery:2.1.0")
    // implementation("com.google.android.play:core:1.10.3")
    // implementation("com.google.android.play:core-ktx:1.8.1")
    // Tạm tắt Firebase để build được
    // implementation(platform("com.google.firebase:firebase-bom:32.7.2"))
    // implementation("com.google.firebase:firebase-analytics")
}

flutter {
    source = "../.."
}
