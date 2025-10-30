package com.bambooByte.horaDoBicho.repositories;

import com.bambooByte.horaDoBicho.entities.Servico;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ServicoRepository extends JpaRepository<Servico, Long> {
}