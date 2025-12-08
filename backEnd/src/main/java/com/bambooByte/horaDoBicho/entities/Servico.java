package com.bambooByte.horaDoBicho.entities;

import com.bambooByte.horaDoBicho.validacoes.FormatacoesComuns;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Servico {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idServico;
    @Column(nullable = false)
    private String nomeServico;
    @Column(nullable = false)
    private String descricaoServico;
    @Column(nullable = false)
    private Double precoServico;

    public Servico() {
    }

    public Servico(Long idServico, String nomeServico, String descricaoServico, Double precoServico) {
        this.idServico = idServico;
        this.nomeServico = nomeServico;
        this.descricaoServico = descricaoServico;
        this.precoServico = precoServico;
    }

    public Long getIdServico() {
        return idServico;
    }

    public void setIdServico(Long idServico) {
        this.idServico = idServico;
    }

    public String getNomeServico() {
        return nomeServico;
    }

    public void setNomeServico(String nomeServico) {
        this.nomeServico = nomeServico;
    }

    public String getDescricaoServico() {
        return descricaoServico;
    }

    public void setDescricaoServico(String descricaoServico) {
        this.descricaoServico = descricaoServico;
    }

    public Double getPrecoServico() {
        return precoServico;
    }

    public void setPrecoServico(Double precoServico) {
        this.precoServico = precoServico;
    }
    
    public String getPrecoServicoFormatado() {
        return FormatacoesComuns.getInstancia().formatarParaMoedaBR(precoServico);
    }
}
