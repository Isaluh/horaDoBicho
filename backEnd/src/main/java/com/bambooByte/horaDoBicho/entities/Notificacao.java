package com.bambooByte.horaDoBicho.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

@Entity
public class Notificacao {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idNotificacao;
    @Column(nullable = false)
    private Long idCliente;
    @Column(nullable = true)
    private Long idAgendamento;
    @Column(nullable = false)
    private String titulo;
    @Column(nullable = false)
    private String descricao;
    @Column(nullable = false)
    private boolean lida;

    public Notificacao() {
    }

    public Notificacao(Long idCliente, String titulo, String descricao, Long idAgendamento) {
        this.idCliente = idCliente;
        this.titulo = titulo;
        this.descricao = descricao;
        this.idAgendamento = idAgendamento;
        this.lida = false;
    }
        public Long getIdAgendamento() {
            return idAgendamento;
        }

        public void setIdAgendamento(Long idAgendamento) {
            this.idAgendamento = idAgendamento;
        }
    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public Long getIdNotificacao() {
        return idNotificacao;
    }

    public void setIdNotificacao(Long idNotificacao) {
        this.idNotificacao = idNotificacao;
    }

    public Long getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(Long idCliente) {
        this.idCliente = idCliente;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public boolean isLida() {
        return lida;
    }

    public void setLida(boolean lida) {
        this.lida = lida;
    }

}
