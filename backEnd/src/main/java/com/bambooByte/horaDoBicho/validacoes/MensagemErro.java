package com.bambooByte.horaDoBicho.validacoes;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;


public class MensagemErro implements Iterator<String> {

    private List<String> mensagens = new LinkedList<>();
    private int indiceAtual = 0;

    public MensagemErro() {}

    public MensagemErro(String mensagem) {
        mensagens.add(mensagem);
    }

    public MensagemErro(StatusValidacao status) {
        mensagens.add(status.getMensagem());
    }

    public MensagemErro(List<StatusValidacao> erros) {
        for (StatusValidacao erro : erros) {
            mensagens.add(erro.getMensagem());
        }
    }

    public List<String> getMensagens() {
        return mensagens;
    }

    public void setMensagens(List<String> mensagens) {
        this.mensagens = mensagens;
        this.indiceAtual = 0;
    }

    @Override
    public boolean hasNext() {
        return indiceAtual < mensagens.size();
    }

    @Override
    public String next() {
        return mensagens.get(indiceAtual++);
    }
}
