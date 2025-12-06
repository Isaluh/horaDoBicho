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

import com.bambooByte.horaDoBicho.entities.AdminInfo;
import com.bambooByte.horaDoBicho.entities.Cliente;
import com.bambooByte.horaDoBicho.services.ClienteService;

@RestController
@RequestMapping("/clientes")
public class ClienteController {

    @Autowired
    private ClienteService clienteService;

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Cliente cliente) {
        if (cliente.getEmailCliente() != null && clienteService.findByEmail(cliente.getEmailCliente()).isPresent()) {
            return ResponseEntity.status(409).body(null);
        }
        try {
            Cliente novoCliente = clienteService.create(cliente);
            return ResponseEntity.ok(novoCliente);
        } catch (IllegalArgumentException e) {
            
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<Cliente>> find(@PathVariable Long id) {
        return ResponseEntity.ok(clienteService.find(id));
    }

    @GetMapping
    public ResponseEntity<List<Cliente>> findAll() {
        return ResponseEntity.ok(clienteService.findAll());
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @RequestBody Cliente novoCliente) {
        return clienteService.find(id)
            .map(clienteExistente -> {
                if (novoCliente.getNomeCliente() != null) {
                    clienteExistente.setNomeCliente(novoCliente.getNomeCliente());
                }

                if (novoCliente.getEmailCliente() != null) {
                    clienteExistente.setEmailCliente(novoCliente.getEmailCliente());
                }

                if (novoCliente.getTelefoneCliente() != null) {
                    clienteExistente.setTelefoneCliente(novoCliente.getTelefoneCliente());
                }

                if (novoCliente.getEnderecoCliente() != null) {
                    clienteExistente.setEnderecoCliente(novoCliente.getEnderecoCliente());
                }

                if (novoCliente.getSenhaCliente() != null && !novoCliente.getSenhaCliente().isEmpty()) {
                    clienteExistente.setSenhaCliente(novoCliente.getSenhaCliente());
                }

                clienteService.update(clienteExistente);
                return ResponseEntity.ok(clienteExistente);
            })
            .orElseGet(() -> ResponseEntity.notFound().build());
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

    @GetMapping("/admin/info")
public ResponseEntity<?> getAdminInfo() {
    Optional<Cliente> adminOpt = clienteService.buscarAdmin();

    if (adminOpt.isPresent()) {
        Cliente admin = adminOpt.get();
        AdminInfo info = new AdminInfo(
            admin.getTelefoneCliente(),
            admin.getEnderecoCliente()
        );

        return ResponseEntity.ok(info);
    }

    return ResponseEntity.status(404).body("Administrador não encontrado.");
}

}