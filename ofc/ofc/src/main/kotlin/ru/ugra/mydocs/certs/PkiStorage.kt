package ru.ugra.mydocs.certs

import net.rubyeye.xmemcached.XMemcachedClient


class PkiStorage {
    private val mc = XMemcachedClient("mc", 11211)

    fun get(enum: Long): Certificate? {
        return mc.get<String>("$enum.Certificate", 3000)?.let { Certificate.unserialize(it) }
    }

    fun put(enum: Long, info: Certificated) {
        mc.set("$enum.${info.javaClass.simpleName}", 3600, info.serialize())
    }
}
