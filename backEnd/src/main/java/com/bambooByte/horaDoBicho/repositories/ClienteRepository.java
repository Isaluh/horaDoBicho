package com.bambooByte.horaDoBicho.repositories;

import com.bambooByte.horaDoBicho.entities.cliente;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ClienteRepository extends JpaRepository<cliente, Long> {
}