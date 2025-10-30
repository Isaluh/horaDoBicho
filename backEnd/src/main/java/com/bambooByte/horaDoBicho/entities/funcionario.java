package com.bambooByte.horaDoBicho.entities;

import jakarta.persistence.*;

@Entity
public class Funcionario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idFuncionario;
    @Column(nullable = false)
    private String nomeFuncionario;
    @Column(nullable = false, unique = true)
    private String cpfFuncionario;
    @Column(nullable = false)
    private String telefoneFuncionario;

    public Funcionario() {
    }

    public Funcionario(Long idFuncionario, String nomeFuncionario, String cpfFuncionario, String telefoneFuncionario) {
        this.idFuncionario = idFuncionario;
        this.nomeFuncionario = nomeFuncionario;
        this.cpfFuncionario = cpfFuncionario;
        this.telefoneFuncionario = telefoneFuncionario;
    }

    public Long getIdFuncionario() {
        return idFuncionario;
    }

    public void setIdFuncionario(Long idFuncionario) {
        this.idFuncionario = idFuncionario;
    }

    public String getNomeFuncionario() {
        return nomeFuncionario;
    }

    public void setNomeFuncionario(String nomeFuncionario) {
        this.nomeFuncionario = nomeFuncionario;
    }

    public String getCpfFuncionario() {
        return cpfFuncionario;
    }

    public void setCpfFuncionario(String cpfFuncionario) {
        this.cpfFuncionario = cpfFuncionario;
    }

    public String getTelefoneFuncionario() {
        return telefoneFuncionario;
    }

    public void setTelefoneFuncionario(String telefoneFuncionario) {
        this.telefoneFuncionario = telefoneFuncionario;
    }

}
