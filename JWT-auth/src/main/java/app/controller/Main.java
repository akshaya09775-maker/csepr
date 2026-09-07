package app.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import app.dto.DataResponse;
import app.services.AuthService;

@RestController
public class Main {

    private final AuthService authService;

    public Main(AuthService authService) {
        this.authService = authService;
    }

    @GetMapping("/api/data")
    public DataResponse getData(
            @RequestHeader(value = "Authorization", required = false) String authHeader) {

        // Validate token (throws AuthException if invalid)
        authService.validateAuthHeader(authHeader);

        // Token is valid - return secure data
        return new DataResponse(
                "Accessing secure wallet 🔐",
                "200 success ✅",
                "🧊🍏🍎🍑🫐✅"
        );
    }
}


