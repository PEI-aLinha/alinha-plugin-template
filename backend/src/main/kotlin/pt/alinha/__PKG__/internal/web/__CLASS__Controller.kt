package pt.alinha.__PKG__.internal.web

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/__ID__")
class __CLASS__Controller {

    /** Walking skeleton: prova que o plugin está carregado de ponta a ponta. */
    @GetMapping("/ping")
    fun ping() = mapOf("plugin" to "__ID__", "status" to "ok")
}
