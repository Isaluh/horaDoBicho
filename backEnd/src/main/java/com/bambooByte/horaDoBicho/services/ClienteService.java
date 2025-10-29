package com.bambooByte.horaDoBicho.services;

import com.bambooByte.horaDoBicho.entities.cliente;
import com.bambooByte.horaDoBicho.repositories.ClienteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClienteService {

    @Autowired
    private ClienteRepository clienteRepository;

    public cliente create(cliente cliente) {
        return clienteRepository.save(cliente);
    }

    public Optional<cliente> find(Long id) {
        return clienteRepository.findById(id);
    }

    public List<cliente> findAll() {
        return clienteRepository.findAll();
    }

    public cliente update(cliente cliente) {
        return clienteRepository.save(cliente);
    }

    public void delete(Long id) {
        clienteRepository.deleteById(id);
    }
}