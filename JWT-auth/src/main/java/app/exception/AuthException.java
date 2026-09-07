package app.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

// This exception automatically returns the correct HTTP status when thrown
@ResponseStatus(HttpStatus.UNAUTHORIZED)
public class AuthException extends RuntimeException {

    public AuthException(String message) {
        super(message);
    }
}
