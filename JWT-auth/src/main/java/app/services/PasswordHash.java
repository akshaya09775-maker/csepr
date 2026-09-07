package app.services;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/password")
public class PasswordHash {

    @PostMapping("/hash")
    public String hash(@RequestBody String password) {
        return manualHash(password);
    }

    public String manualHash(String password) {

        final long PRIME = 31;          // classic multiplier used in polynomial hashing
        final long MODULUS = 1_000_000_007L; // large prime to keep numbers well-distributed

        long hashValue = 7; // starting seed (non-zero so empty strings don't hash to 0)

        for (char c : password.toCharArray()) {
            hashValue = (hashValue * PRIME + c) % MODULUS;
        }

        // Convert the numeric hash into a hex string, so it "looks" like a real hash
        return Long.toHexString(hashValue);
    }
}



