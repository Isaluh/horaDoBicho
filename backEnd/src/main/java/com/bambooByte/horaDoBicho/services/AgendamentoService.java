package com.bambooByte.horaDoBicho.services;

import com.bambooByte.horaDoBicho.entities.Agendamento;
import com.bambooByte.horaDoBicho.repositories.AgendamentoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AgendamentoService {

    @Autowired
    private AgendamentoRepository agendamentoRepository;

    public Agendamento create(Agendamento agendamento) {
        return agendamentoRepository.save(agendamento);
    }

    public Optional<Agendamento> find(Long id) {
        return agendamentoRepository.findById(id);
    }

    public List<Agendamento> findAll() {
        return agendamentoRepository.findAll();
    }

    public Agendamento update(Agendamento agendamento) {
        return agendamentoRepository.save(agendamento);
    }

    public void delete(Long id) {
        agendamentoRepository.deleteById(id);
    }
}