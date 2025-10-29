package com.bambooByte.horaDoBicho.services;

import com.bambooByte.horaDoBicho.entities.funcionario;
import com.bambooByte.horaDoBicho.repositories.FuncionarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class FuncionarioService {

    @Autowired
    private FuncionarioRepository funcionarioRepository;

    public funcionario create(funcionario funcionario) {
        return funcionarioRepository.save(funcionario);
    }

    public Optional<funcionario> find(Long id) {
        return funcionarioRepository.findById(id);
    }

    public List<funcionario> findAll() {
        return funcionarioRepository.findAll();
    }

    public funcionario update(funcionario funcionario) {
        return funcionarioRepository.save(funcionario);
    }

    public void delete(Long id) {
        funcionarioRepository.deleteById(id);
    }
}