package pt.alinha.__PKG__

import org.springframework.stereotype.Component
import pt.alinha.pluginapi.AlinhaPlugin
import pt.alinha.pluginapi.PluginKind
import pt.alinha.pluginapi.PluginManifest

/** Registers the plugin in the core's Module Registry. Keep in sync with plugin.yaml. */
@Component
class __CLASS__Plugin : AlinhaPlugin {
    override val manifest = PluginManifest(
        id = "__ID__",
        name = "__NAME__",
        kind = PluginKind.__KINDUP__,
        version = "0.1.0",
        publishes = setOf(),
        consumes = setOf(),
        permissions = setOf(),
    )
}
