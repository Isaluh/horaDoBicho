package com.bambooByte.horaDoBicho.entities;

import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.*;

@Entity
public class agendamento {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idAgendamento;
    @ManyToOne
    @JoinColumn(name = "idCliente", nullable = false)
    private cliente idCliente;
    @ManyToOne
    @JoinColumn(name = "idPet", nullable = false)
    private pet idPet;
    @ManyToOne
    @JoinColumn(name = "idFuncionario", nullable = false)
    private funcionario idFuncionario;
    @ManyToMany
    @JoinTable(
        name = "agendamento_servico",
        joinColumns = @JoinColumn(name = "idAgendamento"),
        inverseJoinColumns = @JoinColumn(name = "idServico")
    )
    private List<servico> idServico;
    @Column(nullable = false)
    private LocalDateTime dataHoraAgendamento;
    @Column(nullable = false)
    private String observacaoAgendamento;

    public agendamento() {
    }

    public agendamento(Long idAgendamento, cliente idCliente, pet idPet, funcionario idFuncionario,
            List<servico> idServico, LocalDateTime dataHoraAgendamento, String observacaoAgendamento) {
        this.idAgendamento = idAgendamento;
        this.idCliente = idCliente;
        this.idPet = idPet;
        this.idFuncionario = idFuncionario;
        this.idServico = idServico;
        this.dataHoraAgendamento = dataHoraAgendamento;
        this.observacaoAgendamento = observacaoAgendamento;
    }

    public Long getIdAgendamento() {
        return idAgendamento;
    }

    public void setIdAgendamento(Long idAgendamento) {
        this.idAgendamento = idAgendamento;
    }

    public cliente getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(cliente idCliente) {
        this.idCliente = idCliente;
    }

    public pet getIdPet() {
        return idPet;
    }

    public void setIdPet(pet idPet) {
        this.idPet = idPet;
    }

    public funcionario getIdFuncionario() {
        return idFuncionario;
    }

    public void setIdFuncionario(funcionario idFuncionario) {
        this.idFuncionario = idFuncionario;
    }

    public List<servico> getIdServico() {
        return idServico;
    }

    public void setIdServico(List<servico> idServico) {
        this.idServico = idServico;
    }

    public LocalDateTime getDataHoraAgendamento() {
        return dataHoraAgendamento;
    }

    public void setDataHoraAgendamento(LocalDateTime dataHoraAgendamento) {
        this.dataHoraAgendamento = dataHoraAgendamento;
    }

    public String getObservacaoAgendamento() {
        return observacaoAgendamento;
    }

    public void setObservacaoAgendamento(String observacaoAgendamento) {
        this.observacaoAgendamento = observacaoAgendamento;
    }

}
