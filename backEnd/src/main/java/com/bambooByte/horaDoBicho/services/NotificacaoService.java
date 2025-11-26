package com.bambooByte.horaDoBicho.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bambooByte.horaDoBicho.entities.Notificacao;
import com.bambooByte.horaDoBicho.repositories.NotificacaoRepository;

@Service
public class NotificacaoService {
    @Autowired
    private NotificacaoRepository notificacaoRepository;

    public Notificacao criarNotificacao(Long idCliente, String titulo, String descricao, Long idAgendamento) {
        Notificacao notificacao = new Notificacao(idCliente, titulo, descricao, idAgendamento);
        return notificacaoRepository.save(notificacao);
    }
    public void removerNotificacoesPorAgendamentoETituloECliente(Long idAgendamento, String titulo, Long idCliente) {
        notificacaoRepository.deleteAllByAgendamentoTituloClienteQuery(idAgendamento, titulo, idCliente);
    }

    public void removerNotificacoesPorAgendamentoECliente(Long idAgendamento, Long idCliente) {
        notificacaoRepository.deleteAllByAgendamentoAndClienteQuery(idAgendamento, idCliente);
    }
    public Notificacao atualizarStatusLida(Long idNotificacao, boolean lida) {
        Notificacao notificacao = notificacaoRepository.findById(idNotificacao)
                .orElseThrow(() -> new RuntimeException("Notificação não encontrada"));
        notificacao.setLida(lida);
        return notificacaoRepository.save(notificacao);
    }

    public List<Notificacao> listarPorCliente(Long idCliente) {
        return notificacaoRepository.findByIdCliente(idCliente);
    }

    public List<Notificacao> listarPorAgendamento(Long idAgendamento) {
        return notificacaoRepository.findByIdAgendamento(idAgendamento);
    }
}
