plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.cacao"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.cacao"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        ndk {
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86", "x86_64")
        }
    }

    // ✅ Fix lỗi JVM target
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    packagingOptions {
        pickFirsts += listOf(
            "lib/armeabi-v7a/libpytorch_jni.so",
            "lib/arm64-v8a/libpytorch_jni.so",
            "lib/x86/libpytorch_jni.so",
            "lib/x86_64/libpytorch_jni.so"
        )
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
    implementation("org.pytorch:pytorch_android:1.13.1") // ✅ Dùng bản chuẩn
    implementation("org.pytorch:pytorch_android_torchvision:1.13.1") // ✅ Nếu bạn dùng torchvision
}
