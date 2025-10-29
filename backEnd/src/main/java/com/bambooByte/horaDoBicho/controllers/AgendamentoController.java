package com.bambooByte.horaDoBicho.controllers;

import com.bambooByte.horaDoBicho.entities.agendamento;
import com.bambooByte.horaDoBicho.services.AgendamentoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/agendamentos")
public class AgendamentoController {

    @Autowired
    private AgendamentoService agendamentoService;

    @PostMapping
    public ResponseEntity<agendamento> create(@RequestBody agendamento agendamento) {
        return ResponseEntity.ok(agendamentoService.create(agendamento));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<agendamento>> find(@PathVariable Long id) {
        return ResponseEntity.ok(agendamentoService.find(id));
    }

    @GetMapping
    public ResponseEntity<List<agendamento>> findAll() {
        return ResponseEntity.ok(agendamentoService.findAll());
    }

    @PutMapping
    public ResponseEntity<agendamento> update(@RequestBody agendamento agendamento) {
        return ResponseEntity.ok(agendamentoService.update(agendamento));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        agendamentoService.delete(id);
        return ResponseEntity.noContent().build();
    }
}