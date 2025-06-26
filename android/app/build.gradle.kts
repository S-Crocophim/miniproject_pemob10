import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(FileInputStream(localPropertiesFile))
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode")
val flutterVersionName = localProperties.getProperty("flutter.versionName")
val flutterCompileSdkVersion = localProperties.getProperty("flutter.compileSdkVersion")
val flutterTargetSdkVersion = localProperties.getProperty("flutter.targetSdkVersion")
val flutterMinSdkVersion = localProperties.getProperty("flutter.minSdkVersion")


android {
    namespace = "com.example.miniproject_pemob10"

    compileSdk = flutterCompileSdkVersion?.toInt() ?: 34
    
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    defaultConfig {
        applicationId = "com.example.miniproject_pemob10"
        
        minSdkVersion(flutterMinSdkVersion?.toInt() ?: 23)
        
            targetSdk = flutterTargetSdkVersion?.toInt() ?:34
        
        versionCode = flutterVersionCode?.toInt() ?: 1
        versionName = flutterVersionName ?: "1.0"
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