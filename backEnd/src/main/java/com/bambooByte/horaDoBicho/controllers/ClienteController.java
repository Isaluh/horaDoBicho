package com.bambooByte.horaDoBicho.controllers;

import com.bambooByte.horaDoBicho.entities.cliente;
import com.bambooByte.horaDoBicho.services.ClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/clientes")
public class ClienteController {

    @Autowired
    private ClienteService clienteService;

    @PostMapping
    public ResponseEntity<cliente> create(@RequestBody cliente cliente) {
        System.out.println(cliente);
        return ResponseEntity.ok(clienteService.create(cliente));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<cliente>> find(@PathVariable Long id) {
        return ResponseEntity.ok(clienteService.find(id));
    }

    @GetMapping
    public ResponseEntity<List<cliente>> findAll() {
        return ResponseEntity.ok(clienteService.findAll());
    }

    @PutMapping
    public ResponseEntity<cliente> update(@RequestBody cliente cliente) {
        return ResponseEntity.ok(clienteService.update(cliente));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        clienteService.delete(id);
        return ResponseEntity.noContent().build();
    }
}