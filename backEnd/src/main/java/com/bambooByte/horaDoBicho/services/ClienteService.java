package com.bambooByte.horaDoBicho.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bambooByte.horaDoBicho.entities.Cliente;
import com.bambooByte.horaDoBicho.enums.Permissao;
import com.bambooByte.horaDoBicho.repositories.ClienteRepository;
import com.bambooByte.horaDoBicho.validacoes.GatewayValidacao;

@Service
public class ClienteService {

    @Autowired
    private ClienteRepository clienteRepository;

    @Autowired
    private GatewayValidacao gatewayValidacao;

    public Cliente create(Cliente cliente) {
        if (cliente.getPermissaoCliente() == Permissao.COMUM) {
            if (cliente.getNomeCliente() == null || cliente.getNomeCliente().isEmpty() ||
                    cliente.getCpfCliente() == null || cliente.getCpfCliente().isEmpty() ||
                    cliente.getTelefoneCliente() == null || cliente.getTelefoneCliente().isEmpty() ||
                    cliente.getEmailCliente() == null || cliente.getEmailCliente().isEmpty() ||
                    cliente.getSenhaCliente() == null || cliente.getSenhaCliente().isEmpty()) {
                throw new IllegalArgumentException("Campos obrigatórios não preenchidos.");
            }
        }
        // Comentando as validações para permitir o funcionamento sem validações
        // List<StatusValidacao> erros = gatewayValidacao.validarCliente(cliente);
        // if (!erros.isEmpty()) {
        // throw new IllegalArgumentException("Erro de validação: " + erros);
        // }
        return clienteRepository.save(cliente);
    }

    public Optional<Cliente> find(Long id) {
        return clienteRepository.findById(id);
    }

    public List<Cliente> findAll() {
        return clienteRepository.findAll();
    }

    public Cliente update(Cliente cliente) {
        return clienteRepository.save(cliente);
    }

    public void delete(Long id) {
        clienteRepository.deleteById(id);
    }

    public Optional<Cliente> findByEmail(String emailCliente) {
        return clienteRepository.findByEmailCliente(emailCliente);
    }
}