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

import com.bambooByte.horaDoBicho.entities.Funcionario;
import com.bambooByte.horaDoBicho.services.FuncionarioService;

@RestController
@RequestMapping("/funcionarios")
public class FuncionarioController {

    @Autowired
    private FuncionarioService funcionarioService;

    @PostMapping
    public ResponseEntity<Funcionario> create(@RequestBody Funcionario funcionario) {
        return ResponseEntity.ok(funcionarioService.create(funcionario));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<Funcionario>> find(@PathVariable Long id) {
        return ResponseEntity.ok(funcionarioService.find(id));
    }

    @GetMapping
    public ResponseEntity<List<Funcionario>> findAll() {
        return ResponseEntity.ok(funcionarioService.findAll());
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody Funcionario novoFuncionario) {
        return funcionarioService.find(id)
                .map(funcionarioExistente -> {
                    if (novoFuncionario.getNomeFuncionario() != null) {
                        funcionarioExistente.setNomeFuncionario(novoFuncionario.getNomeFuncionario());
                    }

                    if (novoFuncionario.getCpfFuncionario() != null) {
                        funcionarioExistente.setCpfFuncionario(novoFuncionario.getCpfFuncionario());
                    }

                    if (novoFuncionario.getTelefoneFuncionario() != null) {
                        funcionarioExistente.setTelefoneFuncionario(novoFuncionario.getTelefoneFuncionario());
                    }

                    if (novoFuncionario.getCargoFuncionario() != null) {
                        funcionarioExistente.setCargoFuncionario(novoFuncionario.getCargoFuncionario());
                    }

                    funcionarioService.update(funcionarioExistente);
                    return ResponseEntity.ok(funcionarioExistente);
                })
                .orElseGet(() -> ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        funcionarioService.delete(id);
        return ResponseEntity.noContent().build();
    }
}