package com.ved.urlshortner.model;

public class ShortenResponse {

    private final String shortUrl;
    private final String shortCode;

    public ShortenResponse(String shortUrl, String shortCode) {
        this.shortUrl = shortUrl;
        this.shortCode = shortCode;
    }

    public String getShortUrl() { return shortUrl; }
    public String getShortCode() { return shortCode; }
}
