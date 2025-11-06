
package com.bambooByte.horaDoBicho.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bambooByte.horaDoBicho.entities.Notificacao;
import com.bambooByte.horaDoBicho.services.NotificacaoService;

@RestController
@RequestMapping("/notificacoes")
public class NotificacaoController {

    private final NotificacaoService notificacaoService;

    @Autowired
    public NotificacaoController(NotificacaoService notificacaoService) {
        this.notificacaoService = notificacaoService;
    }


    @PostMapping("/criar")
    public Notificacao criarNotificacao(@RequestParam Long idCliente, @RequestParam String descricao) {
        return notificacaoService.criarNotificacao(idCliente, descricao);
    }
  
    @GetMapping("/cliente/{idCliente}")
    public List<Notificacao> listarPorCliente(@PathVariable Long idCliente) {
        return notificacaoService.listarPorCliente(idCliente);
    }
    
}
