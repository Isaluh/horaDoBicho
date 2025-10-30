package com.bambooByte.horaDoBicho.repositories;

import com.bambooByte.horaDoBicho.entities.Agendamento;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AgendamentoRepository extends JpaRepository<Agendamento, Long> {
}