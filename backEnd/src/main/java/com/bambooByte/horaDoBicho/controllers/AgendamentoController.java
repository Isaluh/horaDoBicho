package com.bambooByte.horaDoBicho.controllers;

import java.util.List;
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
    public ResponseEntity<Agendamento> create(@RequestBody Agendamento agendamento) {
        return ResponseEntity.ok(agendamentoService.create(agendamento));
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
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody Agendamento novoAgendamento) {
        Optional<Agendamento> agendamentoOpt = agendamentoService.find(id);
        if (agendamentoOpt.isPresent()) {
            Agendamento agendamentoExistente = agendamentoOpt.get();

            if (novoAgendamento.getIdCliente() != null) {
                agendamentoExistente.setIdCliente(novoAgendamento.getIdCliente());
            }
            if (novoAgendamento.getIdPet() != null) {
                agendamentoExistente.setIdPet(novoAgendamento.getIdPet());
            }
            if (novoAgendamento.getIdFuncionario() != null) {
                agendamentoExistente.setIdFuncionario(novoAgendamento.getIdFuncionario());
            }
            if (novoAgendamento.getIdServico() != null) {
                agendamentoExistente.setIdServico(novoAgendamento.getIdServico());
            }
            if (novoAgendamento.getDataHoraAgendamento() != null) {
                agendamentoExistente.setDataHoraAgendamento(novoAgendamento.getDataHoraAgendamento());
            }
            if (novoAgendamento.getObservacaoAgendamento() != null) {
                agendamentoExistente.setObservacaoAgendamento(novoAgendamento.getObservacaoAgendamento());
            }
            if (novoAgendamento.getStatusAgendamento() != null) {
                agendamentoExistente.setStatusAgendamento(novoAgendamento.getStatusAgendamento());
            }

            agendamentoService.update(agendamentoExistente);
            return ResponseEntity.ok(agendamentoExistente);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<Agendamento> updateStatus(@PathVariable Long id, @RequestBody String status) {
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