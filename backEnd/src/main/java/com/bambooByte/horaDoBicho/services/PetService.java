package com.bambooByte.horaDoBicho.services;

import com.bambooByte.horaDoBicho.entities.Pet;
import com.bambooByte.horaDoBicho.repositories.PetRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PetService {

    @Autowired
    private PetRepository petRepository;

    public Pet create(Pet pet) {
        return petRepository.save(pet);
    }

    public Optional<Pet> find(Long id) {
        return petRepository.findById(id);
    }

    public List<Pet> findAll() {
        return petRepository.findAll();
    }

    public Pet update(Pet pet) {
        return petRepository.save(pet);
    }

    public void delete(Long id) {
        petRepository.deleteById(id);
    }
}