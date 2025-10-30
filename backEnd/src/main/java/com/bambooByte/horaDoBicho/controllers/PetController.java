package com.bambooByte.horaDoBicho.controllers;

import com.bambooByte.horaDoBicho.entities.Pet;
import com.bambooByte.horaDoBicho.services.PetService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

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