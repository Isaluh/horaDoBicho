package com.bambooByte.horaDoBicho.entities;

import java.time.LocalDateTime;
import java.util.List;

import com.bambooByte.horaDoBicho.enums.Status;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;

@Entity
public class Agendamento {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idAgendamento;
    @ManyToOne
    @JoinColumn(name = "idCliente", nullable = false)
    private Cliente idCliente;
    @ManyToOne
    @JoinColumn(name = "idPet", nullable = false)
    private Pet idPet;
    @ManyToOne
    @JoinColumn(name = "idFuncionario", nullable = false)
    private Funcionario idFuncionario;
    @ManyToMany
    @JoinTable(name = "agendamento_servico", joinColumns = @JoinColumn(name = "idAgendamento"), inverseJoinColumns = @JoinColumn(name = "idServico"))
    private List<Servico> idServico;
    @Column(nullable = false)
    private LocalDateTime dataHoraAgendamento;
    @Column(nullable = false)
    private String observacaoAgendamento;

    @Column(nullable = false)
    private Status statusAgendamento;

    public Agendamento() {
    }

    public Agendamento(Long idAgendamento, Cliente idCliente, Pet idPet, Funcionario idFuncionario,
            List<Servico> idServico, LocalDateTime dataHoraAgendamento, String observacaoAgendamento,
            Status statusAgendamento) {
        this.idAgendamento = idAgendamento;
        this.idCliente = idCliente;
        this.idPet = idPet;
        this.idFuncionario = idFuncionario;
        this.idServico = idServico;
        this.dataHoraAgendamento = dataHoraAgendamento;
        this.observacaoAgendamento = observacaoAgendamento;
        this.statusAgendamento = statusAgendamento;
    }

    public Long getIdAgendamento() {
        return idAgendamento;
    }

    public void setIdAgendamento(Long idAgendamento) {
        this.idAgendamento = idAgendamento;
    }

    public Cliente getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(Cliente idCliente) {
        this.idCliente = idCliente;
    }

    public Pet getIdPet() {
        return idPet;
    }

    public void setIdPet(Pet idPet) {
        this.idPet = idPet;
    }

    public Funcionario getIdFuncionario() {
        return idFuncionario;
    }

    public void setIdFuncionario(Funcionario idFuncionario) {
        this.idFuncionario = idFuncionario;
    }

    public List<Servico> getIdServico() {
        return idServico;
    }

    public void setIdServico(List<Servico> idServico) {
        this.idServico = idServico;
    }

    public LocalDateTime getDataHoraAgendamento() {
        return dataHoraAgendamento;
    }

    public void setDataHoraAgendamento(LocalDateTime dataHoraAgendamento) {
        this.dataHoraAgendamento = dataHoraAgendamento;
    }

    public Status getStatusAgendamento() {
        return statusAgendamento;
    }

    public void setStatusAgendamento(Status statusAgendamento) {
        this.statusAgendamento = statusAgendamento;
    }

    public String getObservacaoAgendamento() {
        return observacaoAgendamento;
    }

    public void setObservacaoAgendamento(String observacaoAgendamento) {
        this.observacaoAgendamento = observacaoAgendamento;
    }

}
