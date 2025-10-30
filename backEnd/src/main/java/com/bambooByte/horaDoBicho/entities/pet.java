package com.bambooByte.horaDoBicho.entities;

import jakarta.persistence.*;

@Entity
public class Pet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idPet;
    @Column(nullable = false)
    private String nomePet;
    @Column(nullable = false)
    private String idadePet;
    @Column(nullable = false)
    private String racaPet;
    @Column(nullable = false)
    private String especiePet;
    @Column(nullable = false)
    private Long idCliente; 

    public Pet() {
    }

    public Pet(Long idPet, String nomePet, String idadePet, String racaPet, String especiePet, Long idCliente) {
        this.idPet = idPet;
        this.nomePet = nomePet;
        this.idadePet = idadePet;
        this.racaPet = racaPet;
        this.especiePet = especiePet;
        this.idCliente = idCliente;
    }

    public Long getIdPet() {
        return idPet;
    }

    public void setIdPet(Long idPet) {
        this.idPet = idPet;
    }

    public String getNomePet() {
        return nomePet;
    }

    public void setNomePet(String nomePet) {
        this.nomePet = nomePet;
    }

    public String getIdadePet() {
        return idadePet;
    }

    public void setIdadePet(String idadePet) {
        this.idadePet = idadePet;
    }

    public String getRacaPet() {
        return racaPet;
    }

    public void setRacaPet(String racaPet) {
        this.racaPet = racaPet;
    }

    public String getEspeciePet() {
        return especiePet;
    }

    public void setEspeciePet(String especiePet) {
        this.especiePet = especiePet;
    }

    public Long getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(Long idCliente) {
        this.idCliente = idCliente;
    }
}
