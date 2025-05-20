buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.1' // 예시, 버전 확인 필요
        classpath 'com.google.gms:google-services:4.3.15' // Google Services plugin
        // 기타 classpath 의존성들
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// buildDir 이동 커스텀 설정
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}