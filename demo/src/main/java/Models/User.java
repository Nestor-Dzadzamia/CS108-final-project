package Models;

import java.sql.Timestamp;

public class User {
    private Long id;
    private String username;
    private String email;
    private String hashedPassword;
    private String salt;
    private Timestamp timeCreated;
    private Long numQuizzesCreated;
    private Long numQuizzesTaken;
    private Boolean wasTop1;
    private Boolean takenPractice;

    // Default constructor
    public User() {}

    // Full parameterized constructor
    public User(Long id, String username, String email, String hashedPassword, String salt,
                Timestamp timeCreated, Long numQuizzesCreated, Long numQuizzesTaken,
                Boolean wasTop1, Boolean takenPractice) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.hashedPassword = hashedPassword;
        this.salt = salt;
        this.timeCreated = timeCreated;
        this.numQuizzesCreated = numQuizzesCreated;
        this.numQuizzesTaken = numQuizzesTaken;
        this.wasTop1 = wasTop1;
        this.takenPractice = takenPractice;
    }

    // Getters and Setters

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getHashedPassword() { return hashedPassword; }
    public void setHashedPassword(String hashedPassword) { this.hashedPassword = hashedPassword; }

    public String getSalt() { return salt; }
    public void setSalt(String salt) { this.salt = salt; }

    public Timestamp getTimeCreated() { return timeCreated; }
    public void setTimeCreated(Timestamp timeCreated) { this.timeCreated = timeCreated; }

    public Long getNumQuizzesCreated() { return numQuizzesCreated; }
    public void setNumQuizzesCreated(Long numQuizzesCreated) { this.numQuizzesCreated = numQuizzesCreated; }

    public Long getNumQuizzesTaken() { return numQuizzesTaken; }
    public void setNumQuizzesTaken(Long numQuizzesTaken) { this.numQuizzesTaken = numQuizzesTaken; }

    public Boolean getWasTop1() { return wasTop1; }
    public void setWasTop1(Boolean wasTop1) { this.wasTop1 = wasTop1; }

    public Boolean getTakenPractice() { return takenPractice; }
    public void setTakenPractice(Boolean takenPractice) { this.takenPractice = takenPractice; }
}
