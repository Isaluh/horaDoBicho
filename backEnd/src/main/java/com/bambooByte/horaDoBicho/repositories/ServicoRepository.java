package com.bambooByte.horaDoBicho.repositories;

import com.bambooByte.horaDoBicho.entities.servico;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServicoRepository extends JpaRepository<servico, Long> {
}