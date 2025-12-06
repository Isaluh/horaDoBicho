package com.bambooByte.horaDoBicho.entities;

public class AdminInfo {

    private String telefone;
    private String endereco;

    public AdminInfo(String telefone, String endereco) {
        this.telefone = telefone;
        this.endereco = endereco;
    }

    public String getTelefone() {
        return telefone;
    }

    public String getEndereco() {
        return endereco;
    }
}

