package com.bambooByte.horaDoBicho.entities;

import jakarta.persistence.*;

import com.bambooByte.horaDoBicho.enums.Permissao;
import java.util.List;

@Entity
public class Cliente {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idCliente;
    @Column(nullable = false)
    private String nomeCliente;
    @Column(nullable = false, unique = true)
    private String cpfCliente;
    @Column(nullable = false)
    private String telefoneCliente;
    @Column(nullable = false, unique = true)
    private String emailCliente;
    @Column(nullable = true)
    private String enderecoCliente;
    @Column(nullable = false)
    private String senhaCliente;
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Permissao permissaoCliente;
    @OneToMany(mappedBy = "cliente", cascade = CascadeType.ALL)
    private List<Pet> pets;

    public Cliente() {
    }

    public Cliente(Long idCliente, String nomeCliente, String cpfCliente, String telefoneCliente, String emailCliente,
            String enderecoCliente, String senhaCliente, Permissao permissaoCliente) {

        this.idCliente = idCliente;
        this.nomeCliente = nomeCliente;
        this.cpfCliente = cpfCliente;
        this.telefoneCliente = telefoneCliente;
        this.emailCliente = emailCliente;
        this.enderecoCliente = enderecoCliente;
        this.senhaCliente = senhaCliente;
        this.permissaoCliente = permissaoCliente;
    }

    public Long getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(Long idCliente) {
        this.idCliente = idCliente;
    }

    public String getNomeCliente() {
        return nomeCliente;
    }

    public void setNomeCliente(String nomeCliente) {
        this.nomeCliente = nomeCliente;
    }

    public String getCpfCliente() {
        return cpfCliente;
    }

    public void setCpfCliente(String cpfCliente) {
        this.cpfCliente = cpfCliente;
    }

    public String getTelefoneCliente() {
        return telefoneCliente;
    }

    public void setTelefoneCliente(String telefoneCliente) {
        this.telefoneCliente = telefoneCliente;
    }

    public String getEmailCliente() {
        return emailCliente;
    }

    public void setEmailCliente(String emailCliente) {
        this.emailCliente = emailCliente;
    }

    public String getEnderecoCliente() {
        return enderecoCliente;
    }

    public void setEnderecoCliente(String enderecoCliente) {
        this.enderecoCliente = enderecoCliente;
    }

    public String getSenhaCliente() {
        return senhaCliente;
    }

    public void setSenhaCliente(String senhaCliente) {
        this.senhaCliente = senhaCliente;
    }

    public Permissao getPermissaoCliente() {
        return permissaoCliente;
    }

    public void setPermissaoCliente(Permissao permissaoCliente) {
        this.permissaoCliente = permissaoCliente;
    }

    public List<Pet> getPets() {
        return pets;
    }

    public void setPets(List<Pet> pets) {
        this.pets = pets;
    }
}
