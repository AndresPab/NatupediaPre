// android/build.gradle.kts

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.2")
        // Si usas Kotlin en Android, descomenta y ajusta la versión:
        // classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.22")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // 1) Excluir proguard-parent de TODAS las configuraciones
    configurations.all {
        exclude(group = "net.sf.proguard", module = "proguard-parent")
    }

    // 2) Forzar que proguard-parent resuelva a proguard-base.jar en lugar de .pom
    configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "net.sf.proguard" && requested.name == "proguard-parent") {
                useTarget("net.sf.proguard:proguard-base:${requested.version}")
            }
        }
    }
}

// Si reubicabas buildDir, mantenlo así:
val newBuildDir = rootProject.layout.buildDirectory
    .dir("../../build")
    .get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    evaluationDependsOn(":app")
    val projectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(projectBuildDir)
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
