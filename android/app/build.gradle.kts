import java.util.Properties
import org.gradle.api.file.DuplicatesStrategy

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
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

val flutterVersionCode = localProperties["flutter.versionCode"]?.toString()?.toInt() ?: 1
val flutterVersionName = localProperties["flutter.versionName"]?.toString() ?: "1.0.0"
val ndkVersion = localProperties["ndk.version"]?.toString() ?: "23.1.7779620"

android {
    namespace = "com.coffee2u.coffee2u"
    compileSdk = 35
    this.ndkVersion = ndkVersion

    defaultConfig {
        applicationId = "com.coffee2u.coffee2u"
        minSdk = 24
        targetSdk = 34
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
        languageVersion = "2.0"
    }

    packagingOptions {
        resources.excludes += setOf(
            "META-INF/DEPENDENCIES",
            "META-INF/LICENSE",
            "META-INF/LICENSE.txt",
            "META-INF/license.txt",
            "META-INF/NOTICE",
            "META-INF/NOTICE.txt",
            "META-INF/notice.txt",
            "META-INF/AL2.0",
            "META-INF/LGPL2.1",
            "META-INF/*.kotlin_module",
            "META-INF/versions/9/previous-compilation-data.bin",
            "*/values/values.xml",
            "/META-INF/flutter_app_badger_release.kotlin_module"
        )

        pickFirsts += listOf("**/*.txt", "**/*.version")
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
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            packaging {
                resources {
                    merges += "**/*.properties"
                    excludes += setOf(
                        "META-INF/DEPENDENCIES",
                        "META-INF/LICENSE",
                        "META-INF/LICENSE.txt",
                        "META-INF/license.txt",
                        "META-INF/NOTICE",
                        "META-INF/NOTICE.txt",
                        "META-INF/notice.txt",
                        "META-INF/AL2.0",
                        "META-INF/LGPL2.1",
                        "META-INF/*.kotlin_module",
                        "META-INF/versions/9/previous-compilation-data.bin",
                    )
                    pickFirsts += listOf("**/*.txt", "**/*.version")
                }
            }
        }
    }
}


tasks.withType<Jar>().configureEach {
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
}

flutter {
    source = "../.."
}
