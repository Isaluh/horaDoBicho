package com.bambooByte.horaDoBicho.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.bambooByte.horaDoBicho.entities.Agendamento;

public interface AgendamentoRepository extends JpaRepository<Agendamento, Long> {
	List<Agendamento> findByIdCliente_IdCliente(Long idCliente);

	@org.springframework.data.jpa.repository.Query("SELECT a FROM Agendamento a WHERE (:dataHoraAgendamento IS NULL OR a.dataHoraAgendamento = :dataHoraAgendamento) AND (:idPet IS NULL OR a.idPet.id = :idPet) AND (:idFuncionario IS NULL OR a.idFuncionario.id = :idFuncionario) AND (:idCliente IS NULL OR a.idCliente.id = :idCliente)")
	List<Agendamento> findByFilters(
		@org.springframework.data.repository.query.Param("dataHoraAgendamento") java.time.LocalDateTime dataHoraAgendamento,
		@org.springframework.data.repository.query.Param("idPet") Long idPet,
		@org.springframework.data.repository.query.Param("idFuncionario") Long idFuncionario,
		@org.springframework.data.repository.query.Param("idCliente") Long idCliente
	);
}
