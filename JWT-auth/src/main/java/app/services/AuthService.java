package app.services;

import java.util.Optional;

import org.springframework.stereotype.Service;

import app.dto.MessageResponse;
import app.dto.TokenResponse;
import app.exception.AuthException;
import app.model.User;
import app.repo.UserRepo;

@Service
public class AuthService {

    private final UserRepo userRepo;
    private final JwtService jwtService;

    public AuthService(UserRepo userRepo, JwtService jwtService) {
        this.userRepo = userRepo;
        this.jwtService = jwtService;
    }

    // Register a new user
    public User register(User user) {
        return userRepo.save(user);
    }

    // Login: check credentials, generate token
    public TokenResponse login(String email, String password) {

        Optional<User> optionalUser = userRepo.findByEmail(email);

        if (optionalUser.isEmpty()) {
            throw new AuthException("Email or Password is incorrect");
        }

        User user = optionalUser.get();

        if (!user.getPassword().equals(password)) {
            throw new AuthException("Email or Password is incorrect");
        }

        String token = jwtService.generateToken(email);
        return new TokenResponse(token);
    }

    // Validate the Authorization header
    public MessageResponse validateAuthHeader(String authHeader) {

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            throw new AuthException("Missing or invalid token");
        }

        String token = authHeader.substring(7);

        try {
            jwtService.validateToken(token);
            return new MessageResponse("Token is valid");
        } catch (Exception e) {
            throw new AuthException("Token has expired or is invalid");
        }
    }
}
