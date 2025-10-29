package com.bambooByte.horaDoBicho.controllers;

import com.bambooByte.horaDoBicho.entities.servico;
import com.bambooByte.horaDoBicho.services.ServicoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/servicos")
public class ServicoController {

    @Autowired
    private ServicoService servicoService;

    @PostMapping
    public ResponseEntity<servico> create(@RequestBody servico servico) {
        return ResponseEntity.ok(servicoService.create(servico));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<servico>> find(@PathVariable Long id) {
        return ResponseEntity.ok(servicoService.find(id));
    }

    @GetMapping
    public ResponseEntity<List<servico>> findAll() {
        return ResponseEntity.ok(servicoService.findAll());
    }

    @PutMapping
    public ResponseEntity<servico> update(@RequestBody servico servico) {
        return ResponseEntity.ok(servicoService.update(servico));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        servicoService.delete(id);
        return ResponseEntity.noContent().build();
    }
}