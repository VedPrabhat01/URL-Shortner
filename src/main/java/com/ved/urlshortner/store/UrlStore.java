package com.ved.urlshortner.store;

import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * In-memory URL store backed by a ConcurrentHashMap.
 * Thread-safe for concurrent reads and writes.
 *
 * NOTE: Data is lost on restart. For production persistence,
 * swap this out for a Redis or database-backed implementation.
 */
@Component
public class UrlStore {

    private static final Map<String, String> STORE = new ConcurrentHashMap<>();

    public static void save(String shortCode, String originalUrl) {
        STORE.put(shortCode, originalUrl);
    }

    public static String get(String shortCode) {
        return STORE.get(shortCode);
    }

    /** Useful for health/debug endpoints — returns current store size */
    public static int size() {
        return STORE.size();
    }
}
