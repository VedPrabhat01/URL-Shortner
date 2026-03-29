package com.ved.urlshortner.service;

import com.ved.urlshortner.exception.UrlNotFoundException;
import com.ved.urlshortner.store.UrlStore;
import com.ved.urlshortner.util.HashingUtil;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class UrlShortenerService {

    @Value("${app.base-url}")
    private String baseUrl;

    /**
     * Shortens a URL and stores the mapping.
     * Returns the full short URL (e.g. http://your-domain/abc1234)
     */
    public String shorten(String longUrl) {
        validateUrl(longUrl);
        String shortCode = HashingUtil.generateShortCode(longUrl);
        UrlStore.save(shortCode, longUrl);
        return baseUrl + "/" + shortCode;
    }

    /**
     * Resolves a short code to its original URL.
     * Throws UrlNotFoundException if not found.
     */
    public String resolve(String shortCode) {
        String originalUrl = UrlStore.get(shortCode);
        if (originalUrl == null) {
            throw new UrlNotFoundException(shortCode);
        }
        return originalUrl;
    }

    private void validateUrl(String url) {
        if (url == null || url.isBlank()) {
            throw new IllegalArgumentException("URL must not be empty");
        }
        if (!url.startsWith("http://") && !url.startsWith("https://")) {
            throw new IllegalArgumentException("URL must start with http:// or https://");
        }
    }
}
