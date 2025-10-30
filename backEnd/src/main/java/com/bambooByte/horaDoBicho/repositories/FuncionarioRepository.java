package com.bambooByte.horaDoBicho.repositories;

import com.bambooByte.horaDoBicho.entities.Funcionario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FuncionarioRepository extends JpaRepository<Funcionario, Long> {
}