package app.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

@Entity
@Data
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String email;

    // WRITE_ONLY: password is accepted in requests but never sent in responses
    @JsonProperty(access = JsonProperty.Access.WRITE_ONLY)
    private String password;

    public User() {
    }
}
