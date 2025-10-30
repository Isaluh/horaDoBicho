package com.bambooByte.horaDoBicho.validacoes;

import java.text.NumberFormat;
import java.util.Locale;


public class FormatacoesComuns {

    private static final FormatacoesComuns instancia = new FormatacoesComuns();

    private FormatacoesComuns() {
    }

    public static FormatacoesComuns getInstancia() {
        return instancia;
    }

    public String formatarParaMoedaBR(Double valor) {
        if (valor == null)
            return "R$ 0,00";
        NumberFormat formatter = NumberFormat.getCurrencyInstance(Locale.of("pt", "BR"));
        return formatter.format(valor);
    }
}
