package com.bambooByte.horaDoBicho.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.bambooByte.horaDoBicho.entities.Agendamento;

public interface AgendamentoRepository extends JpaRepository<Agendamento, Long> {
	List<Agendamento> findByIdCliente_IdCliente(Long idCliente);

	List<Agendamento> findByDataHoraAgendamento(
		java.time.LocalDateTime dataHoraAgendamento, Long idPet,
		java.time.LocalDateTime dataHoraAgendamento2, Long idFuncionario,
		java.time.LocalDateTime dataHoraAgendamento3, Long idCliente);
}
