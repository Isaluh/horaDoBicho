package com.bambooByte.horaDoBicho.validacoes;

import java.text.CharacterIterator;
import java.text.StringCharacterIterator;
import java.util.regex.Pattern;

class Validador {

    private static final Validador instancia = new Validador();

    private Validador() {
    }

    public static Validador getInstancia() {
        return instancia;
    }

    public StatusValidacao validaCPF(String CPF) {
        if (CPF == null)
            return StatusValidacao.CPF_INVALIDO;

        CPF = CPF.replaceAll("[^\\d]", "");

        if (CPF.length() != 11)
            return StatusValidacao.CPF_TAMANHO_ERRADO;

        if (CPF.matches("(\\d)\\1{10}"))
            return StatusValidacao.CPF_INVALIDO;

        CharacterIterator it = new StringCharacterIterator(CPF);
        int d1 = 0, d2 = 0, d1Input, d2Input;
        int[] digitos = new int[11];
        int pos = 0;
        while (it.current() != CharacterIterator.DONE) {
            digitos[pos++] = Character.getNumericValue(it.current());
            it.next();
        }

        d1Input = digitos[9];
        d2Input = digitos[10];

        // Cálculo do primeiro dígito
        int val = 0, peso = 10;
        for (int i = 0; i < 9; i++)
            val += digitos[i] * peso--;
        int res1 = val % 11;
        d1 = (res1 < 2) ? 0 : 11 - res1;
        if (d1 != d1Input)
            return StatusValidacao.CPF_INVALIDO;

        // Cálculo do segundo dígito
        val = 0;
        peso = 11;
        for (int i = 0; i < 10; i++)
            val += digitos[i] * peso--;
        int res2 = val % 11;
        d2 = (res2 < 2) ? 0 : 11 - res2;
        if (d2 != d2Input)
            return StatusValidacao.CPF_INVALIDO;

        return null;
    }

    public StatusValidacao validaEmail(String email) {
        if (email == null)
            return StatusValidacao.EMAIL_INVALIDO;

        String regex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,7}$";
        return Pattern.matches(regex, email) ? null : StatusValidacao.EMAIL_INVALIDO;
    }

    public StatusValidacao validaTelefone(String telefone) {
        if (telefone == null || !telefone.matches("^[1-9][0-9]{7,8}$")) {
            return StatusValidacao.TELEFONE_INVALIDO;
        }
        return null;
    }

    public StatusValidacao validaSenha(String senha) {
        if (senha == null || senha.length() < 8) {
            return StatusValidacao.SENHA_FRACA;
        }
        boolean temMaiuscula = senha.matches(".*[A-Z].*");
        boolean temMinuscula = senha.matches(".*[a-z].*");
        boolean temNumero = senha.matches(".*[0-9].*");
        boolean temSimbolo = senha.matches(".*[^a-zA-Z0-9].*");
        if (!temMaiuscula || !temMinuscula || !temNumero || !temSimbolo) {
            return StatusValidacao.SENHA_FRACA;
        }
        return null;
    }

}
