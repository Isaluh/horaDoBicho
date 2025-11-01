package com.bambooByte.horaDoBicho.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.bambooByte.horaDoBicho.entities.Pet;

@Repository
public interface PetRepository extends JpaRepository<Pet, Long> {
    List<Pet> findByClienteIdCliente(Long idCliente);
}

