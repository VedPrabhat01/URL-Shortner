package com.ved.urlshortner.controller;

import com.ved.urlshortner.model.ShortenResponse;
import com.ved.urlshortner.service.UrlShortenerService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;

@RestController
public class UrlShortenerController {

    private final UrlShortenerService urlShortenerService;

    public UrlShortenerController(UrlShortenerService urlShortenerService) {
        this.urlShortenerService = urlShortenerService;
    }

    /** Health check */
    @GetMapping("/")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("URL Shortener service is running");
    }

    /**
     * POST /shorten?longUrl=https://...
     * Returns JSON: { shortUrl, shortCode }
     */
    @PostMapping("/shorten")
    public ResponseEntity<ShortenResponse> shorten(@RequestParam String longUrl) {
        String shortUrl = urlShortenerService.shorten(longUrl);
        String shortCode = shortUrl.substring(shortUrl.lastIndexOf('/') + 1);
        return ResponseEntity.ok(new ShortenResponse(shortUrl, shortCode));
    }

    /**
     * GET /{shortCode}  -> 302 redirect to original URL
     */
    @GetMapping("/{shortCode}")
    public ResponseEntity<Void> redirect(@PathVariable String shortCode) {
        String originalUrl = urlShortenerService.resolve(shortCode);
        return ResponseEntity
                .status(302)
                .location(URI.create(originalUrl))
                .build();
    }
}
