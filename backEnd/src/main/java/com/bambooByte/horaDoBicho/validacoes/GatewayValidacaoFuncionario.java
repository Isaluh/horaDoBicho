package com.bambooByte.horaDoBicho.validacoes;

import java.util.LinkedList;
import java.util.List;
import java.util.Objects;

import org.springframework.stereotype.Component;

import com.bambooByte.horaDoBicho.entities.Funcionario;

@Component
public class GatewayValidacaoFuncionario {
    private Validador validador = Validador.getInstancia();

    public GatewayValidacaoFuncionario() {}

    public List<StatusValidacao> validarFuncionario(Funcionario funcionario) {
        List<StatusValidacao> erros = new LinkedList<>();
        erros.add(validador.validaCPF(funcionario.getCpfFuncionario()));
        erros.add(validador.validaTelefone(funcionario.getTelefoneFuncionario()));
        removerNulos(erros);
        return erros;
    }

    private static void removerNulos(List<StatusValidacao> lista) {
        lista.removeIf(Objects::isNull);
    }
}
