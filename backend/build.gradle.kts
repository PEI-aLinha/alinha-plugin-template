// Subprojeto ":__ID__" do build do repo principal (incluído automaticamente
// pelo settings.gradle.kts de lá). Não compila fora desse checkout.
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
