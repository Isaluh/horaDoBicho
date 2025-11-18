package com.bambooByte.horaDoBicho.entities;

import java.time.LocalDateTime;
import java.util.List;

public class AgendamentoRequest {
    public Long idCliente;
    public Long idPet;
    public Long idFuncionario;
    public List<Long> idServico;
    public LocalDateTime dataHoraAgendamento;
    public String observacaoAgendamento;
    public String descricaoStatus;
    public String statusAgendamento;
    public Double valorTotal;
}
