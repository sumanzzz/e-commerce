package com.cloudcart.repository;
import com.cloudcart.entity.Entities.Role;
import com.cloudcart.entity.Entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;
public interface UserRepository extends JpaRepository<User,Long> {
    Optional<User> findByEmail(String email);
    long countByRole(Role role);
}
