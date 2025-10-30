package com.bambooByte.horaDoBicho.repositories;

import com.bambooByte.horaDoBicho.entities.Cliente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ClienteRepository extends JpaRepository<Cliente, Long> {
    Optional<Cliente> findByEmailCliente(String emailCliente);
}