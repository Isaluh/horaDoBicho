package com.bambooByte.horaDoBicho.controllers;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.bambooByte.horaDoBicho.entities.Pet;
import com.bambooByte.horaDoBicho.services.PetService;

@RestController
@RequestMapping("/pets")
public class PetController {

    @Autowired
    private PetService petService;

    @PostMapping
    public ResponseEntity<Pet> create(@RequestBody Pet pet) {
        return ResponseEntity.ok(petService.create(pet));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<Pet>> find(@PathVariable Long id) {
        return ResponseEntity.ok(petService.find(id));
    }

    @GetMapping
    public ResponseEntity<List<Pet>> findAll() {
        return ResponseEntity.ok(petService.findAll());
    }

    @GetMapping("/idCliente")
    public List<Pet> getPetsByIdCliente(@RequestParam Long idCliente) {
        return petService.findByIdCliente(idCliente);  
    }

    @PutMapping
    public ResponseEntity<Pet> update(@RequestBody Pet pet) {
        return ResponseEntity.ok(petService.update(pet));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        petService.delete(id);
        return ResponseEntity.noContent().build();
    }
}