package com.bambooByte.horaDoBicho.repositories;

import com.bambooByte.horaDoBicho.entities.funcionario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FuncionarioRepository extends JpaRepository<funcionario, Long> {
}