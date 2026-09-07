package app.services;

import java.util.Date;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

@Service
public class JwtService {

    @Value("${jwt.secret}")
    private String secretString;

    // private String secretString="thisisaverylongsecretkeythatshouldbeatleast32bytes";

    private SecretKey getSecret() {
        return Keys.hmacShaKeyFor(secretString.getBytes());
    }

    public String generateToken(String email) {
        return Jwts.builder()
                .subject(email)
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + 30 * 1000)) 
                // 24 hours   24 * 60 * 60 * 1000
                .signWith(getSecret())
                .compact();
    }
 
    public void validateToken(String token) {
        Jwts.parser()
                .verifyWith(getSecret())
                .build()
                .parseSignedClaims(token);
    }

}









