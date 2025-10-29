package com.bambooByte.horaDoBicho.repositories;

import com.bambooByte.horaDoBicho.entities.pet;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PetRepository extends JpaRepository<pet, Long> {
}