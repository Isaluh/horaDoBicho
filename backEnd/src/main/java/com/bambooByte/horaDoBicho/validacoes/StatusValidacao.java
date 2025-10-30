package com.bambooByte.horaDoBicho.validacoes;

public enum StatusValidacao {
    OK("OK"),

    CPF_INVALIDO("CPF inserido é inválido. Verifique os dígitos verificadores."),
    CPF_TAMANHO_ERRADO("CPF deve ter 11 dígitos."),
    EMAIL_INVALIDO("Email inserido é inválido."),
    TELEFONE_INVALIDO("Número de telefone inserido é inválido."),
    PET_NAO_ENCONTRADO("Pet não encontrado no sistema."),
    SEM_CPF_FUNCIONARIO("Faltando CPF do funcionário na requisição."),
    FUNCIONARIO_NAO_ENCONTRADO("Funcionário não encontrado no sistema.");

    private String mensagem;

    private StatusValidacao(String msg) {
        this.mensagem = msg;
    }

    public String getMensagem() {
        return this.mensagem;
    }
}
