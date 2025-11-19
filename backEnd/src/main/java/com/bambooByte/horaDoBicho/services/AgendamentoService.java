
package com.bambooByte.horaDoBicho.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bambooByte.horaDoBicho.entities.Agendamento;
import com.bambooByte.horaDoBicho.enums.Status;
import com.bambooByte.horaDoBicho.repositories.AgendamentoRepository;
import com.bambooByte.horaDoBicho.repositories.ClienteRepository;
import com.bambooByte.horaDoBicho.repositories.FuncionarioRepository;
import com.bambooByte.horaDoBicho.repositories.PetRepository;
import com.bambooByte.horaDoBicho.repositories.ServicoRepository;

@Service
public class AgendamentoService {

    @Autowired
    public NotificacaoService notificacaoService;

    @Autowired
    public AgendamentoRepository agendamentoRepository;

    @Autowired
    public ClienteRepository clienteRepository;
    @Autowired
    public PetRepository petRepository;
    @Autowired
    public FuncionarioRepository funcionarioRepository;
    @Autowired
    public ServicoRepository servicoRepository;

    public Agendamento create(Agendamento agendamento) {
        return agendamentoRepository.save(agendamento);
    }

    public Optional<Agendamento> find(Long id) {
        return agendamentoRepository.findById(id);
    }

    public List<Agendamento> findAll() {
        return agendamentoRepository.findAll();
    }

    public Agendamento update(Agendamento agendamento) {
        return agendamentoRepository.save(agendamento);
    }

    public Agendamento updateStatus(Long idAgendamento, String status, String descricaoStatus) {
        Optional<Agendamento> agendamentoOpt = agendamentoRepository.findById(idAgendamento);
        if (agendamentoOpt.isPresent()) {
            Agendamento agendamento = agendamentoOpt.get();
            Status novoStatus;
            try {
                novoStatus = Status.valueOf(status.toUpperCase());
            } catch (IllegalArgumentException e) {
                throw new RuntimeException("Status inválido: " + status);
            }
            agendamento.setStatusAgendamento(novoStatus);
            agendamento.setDescricaoStatus("Status do agendamento atualizado para: " + novoStatus.name());
            Agendamento salvo = agendamentoRepository.save(agendamento);
            if (novoStatus == Status.CANCELADO) {
                notificacaoService.criarNotificacao(
                        agendamento.getIdCliente().getIdCliente(),
                        "Agendamento Cancelado",
                        "Seu agendamento foi cancelado.",
                        agendamento.getIdAgendamento());
            } else if (novoStatus == Status.APROVADO) {
                notificacaoService.criarNotificacao(
                        agendamento.getIdCliente().getIdCliente(),
                        "Agendamento Aprovado",
                        "Seu agendamento foi aprovado!",
                        agendamento.getIdAgendamento());
            }
            return salvo;
        } else {
            throw new RuntimeException("Agendamento não encontrado");
        }
    }

    public void delete(Long id) {
        agendamentoRepository.deleteById(id);
    }

    public List<Agendamento> findByClienteId(Long idCliente) {
        return agendamentoRepository.findByIdCliente_IdCliente(idCliente);
    }
}