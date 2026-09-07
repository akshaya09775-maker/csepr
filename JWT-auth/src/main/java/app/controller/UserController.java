package app.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;

import app.dto.MessageResponse;
import app.dto.TokenResponse;
import app.model.User;
import app.services.AuthService;

@RestController
public class UserController {

    private final AuthService authService;

    public UserController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/register")
    public User register(@RequestBody User user) {
        return authService.register(user);
    }

    @PostMapping("/login")
    public TokenResponse login(@RequestBody User user) {
        return authService.login(user.getEmail(), user.getPassword());
    }



    

    @GetMapping("/verify")
    public MessageResponse verifyToken(
            @RequestHeader(value = "Authorization", required = false) String authHeader) {
        return authService.validateAuthHeader(authHeader);
    }
}
