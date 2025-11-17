package com.bambooByte.horaDoBicho.controllers;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bambooByte.horaDoBicho.entities.Agendamento;
import com.bambooByte.horaDoBicho.entities.AgendamentoRequest;
import com.bambooByte.horaDoBicho.entities.Servico;
import com.bambooByte.horaDoBicho.enums.Status;
import com.bambooByte.horaDoBicho.services.AgendamentoService;
import com.bambooByte.horaDoBicho.services.NotificacaoService;

@RestController
@RequestMapping("/agendamentos")
public class AgendamentoController {

    @Autowired
    private AgendamentoService agendamentoService;

    @Autowired
    private NotificacaoService notificacaoService;

    @PostMapping
    public ResponseEntity<Agendamento> create(@RequestBody AgendamentoRequest req) {

        Agendamento agendamento = new Agendamento();

        agendamento.setIdCliente(
                agendamentoService.clienteRepository.findById(req.idCliente)
                        .orElseThrow(() -> new RuntimeException("Cliente não encontrado")));

        agendamento.setIdPet(
                agendamentoService.petRepository.findById(req.idPet)
                        .orElseThrow(() -> new RuntimeException("Pet não encontrado")));

        agendamento.setIdFuncionario(
                agendamentoService.funcionarioRepository.findById(req.idFuncionario)
                        .orElseThrow(() -> new RuntimeException("Funcionario não encontrado")));

        agendamento.setIdServico(
                req.idServico.stream()
                        .map(id -> agendamentoService.servicoRepository.findById(id)
                                .orElseThrow(() -> new RuntimeException("Serviço não encontrado: " + id)))
                        .toList());

        agendamento.setDataHoraAgendamento(req.dataHoraAgendamento);
        agendamento.setObservacaoAgendamento(req.observacaoAgendamento != null ? req.observacaoAgendamento : "");
        agendamento.setStatusAgendamento(Status.EM_ANALISE);

        notificacaoService.criarNotificacao(1L, "Novo agendamento criado e aguardando análise.");

        Agendamento salvo = agendamentoService.create(agendamento);
        return ResponseEntity.status(201).body(salvo);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<Agendamento>> find(@PathVariable Long id) {
        return ResponseEntity.ok(agendamentoService.find(id));
    }

    @GetMapping
    public ResponseEntity<List<Agendamento>> findAll() {
        return ResponseEntity.ok(agendamentoService.findAll());
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody AgendamentoRequest req) {

        Optional<Agendamento> agendamentoOpt = agendamentoService.find(id);
        if (agendamentoOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }

        Agendamento agendamento = agendamentoOpt.get();

        if (req.idPet != null) {
            agendamento.setIdPet(
                    agendamentoService.petRepository.findById(req.idPet)
                            .orElseThrow(() -> new RuntimeException("Pet não encontrado")));
        }

        if (req.idFuncionario != null) {
            agendamento.setIdFuncionario(
                    agendamentoService.funcionarioRepository.findById(req.idFuncionario)
                            .orElseThrow(() -> new RuntimeException("Funcionário não encontrado")));
        }

        if (req.idServico != null) {

            List<Servico> novosServicos = req.idServico.stream()
                    .map(servicoId ->
                            agendamentoService.servicoRepository.findById(servicoId)
                                    .orElseThrow(() -> new RuntimeException("Serviço não encontrado: " + servicoId))
                    )
                    .toList();

            agendamento.getIdServico().clear();
            agendamento.getIdServico().addAll(novosServicos);
        }

        if (req.dataHoraAgendamento != null) {
            agendamento.setDataHoraAgendamento(req.dataHoraAgendamento);
        }

        if (req.observacaoAgendamento != null) {
            agendamento.setObservacaoAgendamento(req.observacaoAgendamento);
        }

        agendamentoService.update(agendamento);

        return ResponseEntity.ok(agendamento);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<Agendamento> updateStatus(@PathVariable Long id, @RequestBody Map<String, String> requestBody) {
        String status = requestBody.get("statusAgendamento");
        if (status == null) {
            throw new RuntimeException("Campo statusAgendamento é obrigatório");
        }

        Agendamento agendamento = agendamentoService.updateStatus(id, status);

        if (agendamento != null && agendamento.getIdCliente() != null) {
            String descricao = "Status do agendamento atualizado para: " + status;
            Long idCliente = agendamento.getIdCliente().getIdCliente();
            notificacaoService.criarNotificacao(idCliente, descricao);
        }
        return ResponseEntity.ok(agendamento);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        agendamentoService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/cliente/{idCliente}")
    public ResponseEntity<List<Agendamento>> findByClienteId(@PathVariable Long idCliente) {
        return ResponseEntity.ok(agendamentoService.findByClienteId(idCliente));
    }
}