package com.bambooByte.horaDoBicho.services;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bambooByte.horaDoBicho.entities.Funcionario;
import com.bambooByte.horaDoBicho.repositories.FuncionarioRepository;
import com.bambooByte.horaDoBicho.validacoes.GatewayValidacaoFuncionario;
import com.bambooByte.horaDoBicho.validacoes.StatusValidacao;

@Service
public class FuncionarioService {

    @Autowired
    private FuncionarioRepository funcionarioRepository;

    public Funcionario create(Funcionario funcionario) {
        GatewayValidacaoFuncionario gatewayValidacaoFuncionario = new GatewayValidacaoFuncionario();
        List<StatusValidacao> erros = gatewayValidacaoFuncionario.validarFuncionario(funcionario);
        if (!erros.isEmpty()) {
            throw new IllegalArgumentException("Erro de validação: " + erros);
        }
        return funcionarioRepository.save(funcionario);
    }

    public Optional<Funcionario> find(Long id) {
        return funcionarioRepository.findById(id);
    }

    public List<Funcionario> findAll() {
        return funcionarioRepository.findAll();
    }

    public Funcionario update(Funcionario funcionario) {
        return funcionarioRepository.save(funcionario);
    }

    public void delete(Long id) {
        funcionarioRepository.deleteById(id);
    }
}