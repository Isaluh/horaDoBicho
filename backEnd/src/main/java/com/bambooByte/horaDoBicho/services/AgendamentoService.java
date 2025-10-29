package com.bambooByte.horaDoBicho.services;

import com.bambooByte.horaDoBicho.entities.agendamento;
import com.bambooByte.horaDoBicho.repositories.AgendamentoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AgendamentoService {

    @Autowired
    private AgendamentoRepository agendamentoRepository;

    public agendamento create(agendamento agendamento) {
        return agendamentoRepository.save(agendamento);
    }

    public Optional<agendamento> find(Long id) {
        return agendamentoRepository.findById(id);
    }

    public List<agendamento> findAll() {
        return agendamentoRepository.findAll();
    }

    public agendamento update(agendamento agendamento) {
        return agendamentoRepository.save(agendamento);
    }

    public void delete(Long id) {
        agendamentoRepository.deleteById(id);
    }
}