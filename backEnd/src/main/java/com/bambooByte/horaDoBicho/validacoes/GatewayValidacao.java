package com.bambooByte.horaDoBicho.validacoes;

import java.util.LinkedList;
import java.util.List;
import java.util.Objects;

import org.springframework.stereotype.Component;

import com.bambooByte.horaDoBicho.entities.Cliente;

@Component
public class GatewayValidacao {

    private Validador validador = Validador.getInstancia();

    public GatewayValidacao() {
    }

    public List<StatusValidacao> validarCliente(Cliente novoCliente) {
        List<StatusValidacao> erros = new LinkedList<>();
        // Se for admin, ignora validação de CPF, telefone, email e senha
        if (novoCliente.getPermissaoCliente() != null && !"ADMIN".equalsIgnoreCase(novoCliente.getPermissaoCliente().name())) {
            erros.add(this.validador.validaCPF(novoCliente.getCpfCliente()));
            erros.add(this.validador.validaEmail(novoCliente.getEmailCliente()));
            erros.add(this.validador.validaTelefone(novoCliente.getTelefoneCliente()));
            erros.add(this.validador.validaSenha(novoCliente.getSenhaCliente()));
        }
        removerNulos(erros);
        return erros;
    }

    private static void removerNulos(List<StatusValidacao> lista) {
        lista.removeIf(Objects::isNull);
    }

}
