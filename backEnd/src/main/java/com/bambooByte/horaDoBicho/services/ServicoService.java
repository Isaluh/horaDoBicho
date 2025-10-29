package com.bambooByte.horaDoBicho.services;

import com.bambooByte.horaDoBicho.entities.servico;
import com.bambooByte.horaDoBicho.repositories.ServicoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ServicoService {

    @Autowired
    private ServicoRepository servicoRepository;

    public servico create(servico servico) {
        return servicoRepository.save(servico);
    }

    public Optional<servico> find(Long id) {
        return servicoRepository.findById(id);
    }

    public List<servico> findAll() {
        return servicoRepository.findAll();
    }

    public servico update(servico servico) {
        return servicoRepository.save(servico);
    }

    public void delete(Long id) {
        servicoRepository.deleteById(id);
    }
}