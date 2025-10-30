package com.bambooByte.horaDoBicho.controllers;

import com.bambooByte.horaDoBicho.entities.Cliente;
import com.bambooByte.horaDoBicho.services.ClienteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/clientes")
public class ClienteController {

    @Autowired
    private ClienteService clienteService;

    @PostMapping
    public ResponseEntity<Cliente> create(@RequestBody Cliente cliente) {
        System.out.println(cliente);
        return ResponseEntity.ok(clienteService.create(cliente));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<Cliente>> find(@PathVariable Long id) {
        return ResponseEntity.ok(clienteService.find(id));
    }

    @GetMapping
    public ResponseEntity<List<Cliente>> findAll() {
        return ResponseEntity.ok(clienteService.findAll());
    }

    @PutMapping
    public ResponseEntity<Cliente> update(@RequestBody Cliente cliente) {
        return ResponseEntity.ok(clienteService.update(cliente));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        clienteService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> loginData) {
        String email = loginData.get("emailCliente");
        String senha = loginData.get("senhaCliente");

        Optional<Cliente> clienteOptional = clienteService.findByEmail(email);

        if (clienteOptional.isPresent()) {
            Cliente cliente = clienteOptional.get();
            if (cliente.getSenhaCliente().equals(senha)) {
                return ResponseEntity.ok(cliente);
            } else {
                return ResponseEntity.status(401).body("Senha incorreta.");
            }
        } else {
            return ResponseEntity.status(404).body("Usuário não encontrado.");
        }
    }
}