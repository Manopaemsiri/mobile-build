import java.util.Properties
import org.gradle.api.file.DuplicatesStrategy

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

fun loadProperties(fileName: String): Properties {
    val props = Properties()
    val propFile = rootProject.file(fileName)
    if (propFile.exists()) {
        props.load(propFile.inputStream())
    }
    return props
}


val keystoreProperties = loadProperties("key.properties")
val localProperties = loadProperties("local.properties")
val flutterRoot = localProperties.getProperty("flutter.sdk")


android {
    namespace = "com.coffee2u.coffee2u"
    compileSdk = 34
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.coffee2u.coffee2u"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = (keystoreProperties["storeFile"] as? String)?.let { file(it) }
        storePassword = keystoreProperties["storePassword"] as String
    }
}

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now,
            // so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
        }
    }
      packagingOptions {
        resources.excludes.addAll(
            listOf(
                "/META-INF/{AL2.0,LGPL2.1}",
                "/META-INF/DEPENDENCIES",
                "/META-INF/LICENSE*",
                "/META-INF/NOTICE*",
                "/META-INF/*.kotlin_module",
                "**/kotlin/**",
                "**/*.version",
                "**/*.properties",
                "META-INF/INDEX.LIST",
                "META-INF/com.android.tools/proguard/coroutines.pro"
            )
        )
    }

    tasks.withType<Jar>().configureEach {
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
}

}

flutter {
    source = "../.."
}
