package pt.alinha.__PKG__

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class __CLASS__PluginTest {
    @Test
    fun `manifest has the plugin id`() {
        assertEquals("__ID__", __CLASS__Plugin().manifest.id)
    }
}
