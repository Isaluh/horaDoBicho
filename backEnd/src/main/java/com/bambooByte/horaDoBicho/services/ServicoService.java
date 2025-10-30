package com.bambooByte.horaDoBicho.services;

import com.bambooByte.horaDoBicho.entities.Servico;
import com.bambooByte.horaDoBicho.repositories.ServicoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ServicoService {

    @Autowired
    private ServicoRepository servicoRepository;

    public Servico create(Servico servico) {
        return servicoRepository.save(servico);
    }

    public Optional<Servico> find(Long id) {
        return servicoRepository.findById(id);
    }

    public List<Servico> findAll() {
        return servicoRepository.findAll();
    }

    public Servico update(Servico servico) {
        return servicoRepository.save(servico);
    }

    public void delete(Long id) {
        servicoRepository.deleteById(id);
    }
}