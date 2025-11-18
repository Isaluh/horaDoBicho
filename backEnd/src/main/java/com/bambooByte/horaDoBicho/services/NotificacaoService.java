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

    public Notificacao criarNotificacao(Long idCliente, String titulo, String descricaoStatus, String descricao) {
        Notificacao notificacao = new Notificacao(idCliente, titulo, descricaoStatus, descricao);
        return notificacaoRepository.save(notificacao);
    }

    public List<Notificacao> listarPorCliente(Long idCliente) {
        return notificacaoRepository.findByIdCliente(idCliente);
    }
}
