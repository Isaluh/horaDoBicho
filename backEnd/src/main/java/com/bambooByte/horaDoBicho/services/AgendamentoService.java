
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
        Optional<Agendamento> originalOpt = agendamentoRepository.findById(agendamento.getIdAgendamento());
        Agendamento original = originalOpt.orElse(null);

        boolean agendamentoRecusadoEditado = false;
        if (original != null && original.getStatusAgendamento() == Status.RECUSADO) {
            agendamento.setStatusAgendamento(Status.EM_ANALISE);
            agendamentoRecusadoEditado = true;
        }

        Agendamento salvo = agendamentoRepository.save(agendamento);

        if (agendamentoRecusadoEditado && agendamento.getIdFuncionario() != null) {
            System.out.println("[LOG] Notificação enviada para admin! idFuncionario=" + agendamento.getIdFuncionario().getIdFuncionario());
            notificacaoService.criarNotificacao(
                agendamento.getIdFuncionario().getIdFuncionario(),
                "Agendamento para revisão",
                "O cliente alterou um agendamento recusado. Verifique novamente.",
                agendamento.getIdAgendamento()
            );
        }
        return salvo;
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
            agendamento.setDescricaoStatus(descricaoStatus != null && !descricaoStatus.isBlank()
                ? descricaoStatus
                : "");
            Agendamento salvo = agendamentoRepository.save(agendamento);

            if (novoStatus == Status.APROVADO) {
                try {
                    notificacaoService.removerNotificacoesPorAgendamentoECliente(
                        agendamento.getIdAgendamento(),
                        agendamento.getIdCliente().getIdCliente()
                    );
                } catch (Exception ex) {
                    System.out.println("[WARN] Falha ao remover notificações antigas: " + ex.getMessage());
                }
                notificacaoService.criarNotificacao(
                    agendamento.getIdCliente().getIdCliente(),
                    "Agendamento Aprovado",
                    (descricaoStatus != null && !descricaoStatus.isBlank()) ? "Motivo: " + descricaoStatus : "",
                    agendamento.getIdAgendamento()
                );
            } else if (novoStatus == Status.RECUSADO) {
                notificacaoService.criarNotificacao(
                    agendamento.getIdCliente().getIdCliente(),
                    "Agendamento Recusado",
                    (descricaoStatus != null && !descricaoStatus.isBlank()) ? "Motivo: " + descricaoStatus : "",
                    agendamento.getIdAgendamento()
                );
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