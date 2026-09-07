package app.repo;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import app.model.User;

@Repository
public interface UserRepo extends JpaRepository<User, Long> {

    // Find user by email only - we check password manually in AuthService
    Optional<User> findByEmail(String email);
}



