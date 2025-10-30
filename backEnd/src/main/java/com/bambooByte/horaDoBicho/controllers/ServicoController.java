package com.bambooByte.horaDoBicho.controllers;

import com.bambooByte.horaDoBicho.entities.Servico;
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
    public ResponseEntity<Servico> create(@RequestBody Servico servico) {
        return ResponseEntity.ok(servicoService.create(servico));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<Servico>> find(@PathVariable Long id) {
        return ResponseEntity.ok(servicoService.find(id));
    }

    @GetMapping
    public ResponseEntity<List<Servico>> findAll() {
        return ResponseEntity.ok(servicoService.findAll());
    }

    @PutMapping
    public ResponseEntity<Servico> update(@RequestBody Servico servico) {
        return ResponseEntity.ok(servicoService.update(servico));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        servicoService.delete(id);
        return ResponseEntity.noContent().build();
    }
}