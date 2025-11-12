
package com.bambooByte.horaDoBicho.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bambooByte.horaDoBicho.entities.Agendamento;
import com.bambooByte.horaDoBicho.enums.Status;
import com.bambooByte.horaDoBicho.repositories.AgendamentoRepository;

@Service
public class AgendamentoService {

    @Autowired
    private NotificacaoService notificacaoService;

    @Autowired
    private AgendamentoRepository agendamentoRepository;

    @Autowired
    private com.bambooByte.horaDoBicho.repositories.ClienteRepository clienteRepository;
    @Autowired
    private com.bambooByte.horaDoBicho.repositories.PetRepository petRepository;
    @Autowired
    private com.bambooByte.horaDoBicho.repositories.FuncionarioRepository funcionarioRepository;
    @Autowired
    private com.bambooByte.horaDoBicho.repositories.ServicoRepository servicoRepository;

    public Agendamento create(Agendamento agendamento) {
        if (agendamento.getIdCliente() != null && agendamento.getIdCliente().getIdCliente() != null) {
            agendamento.setIdCliente(clienteRepository.findById(agendamento.getIdCliente().getIdCliente())
                    .orElseThrow(() -> new RuntimeException("Cliente não encontrado")));
        }
        if (agendamento.getIdPet() != null && agendamento.getIdPet().getIdPet() != null) {
            agendamento.setIdPet(petRepository.findById(agendamento.getIdPet().getIdPet())
                    .orElseThrow(() -> new RuntimeException("Pet não encontrado")));
        }
        if (agendamento.getIdFuncionario() != null && agendamento.getIdFuncionario().getIdFuncionario() != null) {
            agendamento
                    .setIdFuncionario(funcionarioRepository.findById(agendamento.getIdFuncionario().getIdFuncionario())
                            .orElseThrow(() -> new RuntimeException("Funcionário não encontrado")));
        }
        if (agendamento.getIdServico() != null && !agendamento.getIdServico().isEmpty()) {
            java.util.List<com.bambooByte.horaDoBicho.entities.Servico> servicos = new java.util.ArrayList<>();
            for (com.bambooByte.horaDoBicho.entities.Servico s : agendamento.getIdServico()) {
                if (s.getIdServico() != null) {
                    servicos.add(servicoRepository.findById(s.getIdServico())
                            .orElseThrow(() -> new RuntimeException("Serviço não encontrado: " + s.getIdServico())));
                }
            }
            agendamento.setIdServico(servicos);
        }

        // Validação de data: só permite hoje até 2 meses depois
        java.time.LocalDateTime hoje = java.time.LocalDateTime.now();
        java.time.LocalDateTime limite = hoje.plusMonths(2);
        if (agendamento.getDataHoraAgendamento().isBefore(hoje)
                || agendamento.getDataHoraAgendamento().isAfter(limite)) {
            throw new RuntimeException("Data de agendamento fora do permitido");
        }

        // Garante que observacaoAgendamento não seja nulo
        if (agendamento.getObservacaoAgendamento() == null) {
            agendamento.setObservacaoAgendamento("");
        }

        // Verificação de conflito
        boolean conflito = !agendamentoRepository
                .findByFilters(
                        agendamento.getDataHoraAgendamento(),
                        agendamento.getIdPet().getIdPet(),
                        agendamento.getIdFuncionario().getIdFuncionario(),
                        agendamento.getIdCliente().getIdCliente())
                .isEmpty();
        agendamento.setStatusAgendamento(Status.EM_ANALISE);

        // Notificação para admin
        notificacaoService.criarNotificacao(1L, "Novo agendamento criado e aguardando análise."); // 1L = id do admin
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

    public Agendamento updateStatus(Long idAgendamento, String status) {
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
            Agendamento salvo = agendamentoRepository.save(agendamento);
            if (novoStatus == Status.CANCELADO) {
                notificacaoService.criarNotificacao(
                        agendamento.getIdCliente().getIdCliente(),
                        "Seu agendamento foi cancelado. Motivo: ...");
            } else if (novoStatus == Status.APROVADO) {
                notificacaoService.criarNotificacao(
                        agendamento.getIdCliente().getIdCliente(),
                        "Seu agendamento foi aprovado!");
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