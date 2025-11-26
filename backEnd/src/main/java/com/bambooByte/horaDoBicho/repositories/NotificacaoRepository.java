package com.bambooByte.horaDoBicho.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.bambooByte.horaDoBicho.entities.Notificacao;

@Repository
public interface NotificacaoRepository extends JpaRepository<Notificacao, Long> {
    List<Notificacao> findByIdCliente(Long idCliente);
    void deleteAllByIdAgendamentoAndTituloAndIdCliente(Long idAgendamento, String titulo, Long idCliente);
    List<Notificacao> findByIdAgendamento(Long idAgendamento);
    void deleteAllByIdAgendamentoAndIdCliente(Long idAgendamento, Long idCliente);

    @Modifying
    @Transactional
    @Query("delete from Notificacao n where n.idAgendamento = :idAgendamento and n.idCliente = :idCliente")
    void deleteAllByAgendamentoAndClienteQuery(Long idAgendamento, Long idCliente);

    @Modifying
    @Transactional
    @Query("delete from Notificacao n where n.idAgendamento = :idAgendamento and n.titulo = :titulo and n.idCliente = :idCliente")
    void deleteAllByAgendamentoTituloClienteQuery(Long idAgendamento, String titulo, Long idCliente);
}
