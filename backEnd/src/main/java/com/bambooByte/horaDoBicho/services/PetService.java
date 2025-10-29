package com.bambooByte.horaDoBicho.services;

import com.bambooByte.horaDoBicho.entities.pet;
import com.bambooByte.horaDoBicho.repositories.PetRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PetService {

    @Autowired
    private PetRepository petRepository;

    public pet create(pet pet) {
        return petRepository.save(pet);
    }

    public Optional<pet> find(Long id) {
        return petRepository.findById(id);
    }

    public List<pet> findAll() {
        return petRepository.findAll();
    }

    public pet update(pet pet) {
        return petRepository.save(pet);
    }

    public void delete(Long id) {
        petRepository.deleteById(id);
    }
}