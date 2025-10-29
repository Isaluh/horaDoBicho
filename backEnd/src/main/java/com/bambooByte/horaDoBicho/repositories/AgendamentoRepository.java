package com.bambooByte.horaDoBicho.repositories;

import com.bambooByte.horaDoBicho.entities.agendamento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AgendamentoRepository extends JpaRepository<agendamento, Long> {
}