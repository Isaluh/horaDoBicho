package com.bambooByte.horaDoBicho.controllers;

import com.bambooByte.horaDoBicho.entities.funcionario;
import com.bambooByte.horaDoBicho.services.FuncionarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/funcionarios")
public class FuncionarioController {

    @Autowired
    private FuncionarioService funcionarioService;

    @PostMapping
    public ResponseEntity<funcionario> create(@RequestBody funcionario funcionario) {
        return ResponseEntity.ok(funcionarioService.create(funcionario));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<funcionario>> find(@PathVariable Long id) {
        return ResponseEntity.ok(funcionarioService.find(id));
    }

    @GetMapping
    public ResponseEntity<List<funcionario>> findAll() {
        return ResponseEntity.ok(funcionarioService.findAll());
    }

    @PutMapping
    public ResponseEntity<funcionario> update(@RequestBody funcionario funcionario) {
        return ResponseEntity.ok(funcionarioService.update(funcionario));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        funcionarioService.delete(id);
        return ResponseEntity.noContent().build();
    }
}