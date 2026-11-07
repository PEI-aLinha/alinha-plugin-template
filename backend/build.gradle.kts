// Subproject ":__ID__" of the main repo's build (included automatically by
// its settings.gradle.kts). Does not build outside that checkout.
plugins {
    alias(libs.plugins.kotlin.jvm)
    alias(libs.plugins.kotlin.spring)
    alias(libs.plugins.kotlin.jpa)
}

dependencies {
    implementation(platform(libs.spring.boot.bom))
    implementation(platform(libs.spring.modulith.bom))

    implementation(project(":plugin-api"))
    implementation(project(":core"))

    implementation(libs.spring.boot.starter.webmvc)
    implementation(libs.spring.boot.starter.data.jpa)
    implementation(libs.spring.modulith.starter.core)

    testImplementation(libs.spring.boot.starter.test)
}
