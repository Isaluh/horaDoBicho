package com.bambooByte.horaDoBicho.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Enumerated;
import jakarta.persistence.EnumType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import com.bambooByte.horaDoBicho.enums.Sexo;

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

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Sexo sexoPet;

    @Column(name = "id_cliente", nullable = false)
    private Long idCliente;

    public Pet() {
    }

    public Pet(Long idPet, String nomePet, String idadePet, String racaPet, String especiePet,
               Sexo sexoPet, Long idCliente) {
        this.idPet = idPet;
        this.nomePet = nomePet;
        this.idadePet = idadePet;
        this.racaPet = racaPet;
        this.especiePet = especiePet;
        this.sexoPet = sexoPet;
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

    public Sexo getSexoPet() {
        return sexoPet;
    }

    public void setSexoPet(Sexo sexoPet) {
        this.sexoPet = sexoPet;
    }

    public Long getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(Long idCliente) {
        this.idCliente = idCliente;
    }
}
