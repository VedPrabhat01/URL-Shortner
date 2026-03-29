package com.ved.urlshortner.util;

import com.google.common.hash.Hashing;
import java.nio.charset.StandardCharsets;

public class HashingUtil {

    private static final String BASE62 =
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    // 62^7 is the correct upper bound for a 7-character string
    private static final long MAX = 3521614606208L;

    public static String generateShortCode(String url) {
        // Use Guava's Murmur3 128-bit and take the first 64 bits as a long
        long hash = Hashing.murmur3_128().hashString(url, StandardCharsets.UTF_8).asLong();

        // Ensure positive and stay within the 7-character Base62 limit
        long positiveHash = (hash & Long.MAX_VALUE) % MAX;

        return toBase62(positiveHash);
    }

    private static String toBase62(long value) {
        StringBuilder sb = new StringBuilder();

        // Standard Base62 conversion
        while (value > 0) {
            sb.append(BASE62.charAt((int) (value % 62)));
            value /= 62;
        }

        // Pad with 'a' (the zero-index char) until we hit 7 characters
        while (sb.length() < 7) {
            sb.append(BASE62.charAt(0));
        }

        // Reverse to maintain correct power-of-62 ordering
        return sb.reverse().toString();
    }
}