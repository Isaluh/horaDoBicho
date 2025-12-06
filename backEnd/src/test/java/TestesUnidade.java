
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import com.bambooByte.horaDoBicho.entities.Cliente;
import com.bambooByte.horaDoBicho.entities.Funcionario;
import com.bambooByte.horaDoBicho.entities.Pet;
import com.bambooByte.horaDoBicho.entities.Servico;
import com.bambooByte.horaDoBicho.repositories.ClienteRepository;
import com.bambooByte.horaDoBicho.repositories.FuncionarioRepository;
import com.bambooByte.horaDoBicho.repositories.PetRepository;
import com.bambooByte.horaDoBicho.repositories.ServicoRepository;
import org.mockito.Mockito;
import java.util.Optional;

public class TestesUnidade {
    
    public TestesUnidade() {
    }
    
    @BeforeAll
    public static void setUpClass() {
    }
    
    @AfterAll
    public static void tearDownClass() {
    }
    
    @BeforeEach
    public void setUp() {
    }
    
    @AfterEach
    public void tearDown() {
    }
        @Test
        public void testCadastroCliente() {
            Cliente cliente = new Cliente();
            cliente.setNomeCliente("João");
            cliente.setEmailCliente("joao@email.com");
            cliente.setTelefoneCliente("11999999999");
            cliente.setCpfCliente("99999999999");
            ClienteRepository repo = Mockito.mock(ClienteRepository.class);
            Mockito.when(repo.findByEmailCliente("joao@email.com")).thenReturn(Optional.of(cliente));
            repo.save(cliente);
            Cliente encontrado = repo.findByEmailCliente("joao@email.com").orElse(null);
            assertNotNull(encontrado);
            assertEquals("João", encontrado.getNomeCliente());
        }
        
    
        @Test
        public void testCadastroPet() {
            Pet pet = new Pet();
            pet.setNomePet("Rex");
            pet.setEspeciePet("Cachorro");
            pet.setIdadePet("3");
            pet.setRacaPet("Labrador");
            PetRepository repo = Mockito.mock(PetRepository.class);
            Mockito.when(repo.findById(1L)).thenReturn(Optional.of(pet));
            repo.save(pet);
            Pet encontrado = repo.findById(1L).orElse(null);
            assertNotNull(encontrado);
            assertEquals("Cachorro", encontrado.getEspeciePet());
        }
    
        @Test
        public void testCadastroFuncionario() {
            Funcionario funcionario = new Funcionario();
            funcionario.setNomeFuncionario("Maria");
            funcionario.setCpfFuncionario("99999999999");
            funcionario.setTelefoneFuncionario("11999999999");
            FuncionarioRepository repo = Mockito.mock(FuncionarioRepository.class);
            Mockito.when(repo.findById(1L)).thenReturn(Optional.of(funcionario));
            repo.save(funcionario);
            Funcionario encontrado = repo.findById(1L).orElse(null);
            assertNotNull(encontrado);
            assertEquals("Maria", encontrado.getNomeFuncionario());
        }
    
        @Test
        public void testCadastroServico() {
            Servico servico = new Servico();
            servico.setNomeServico("Banho");
            servico.setDescricaoServico("Banho completo para cães e gatos");
            servico.setPrecoServico(50.0);
            ServicoRepository repo = Mockito.mock(ServicoRepository.class);
            Mockito.when(repo.findById(1L)).thenReturn(Optional.of(servico));
            repo.save(servico);
            Servico encontrado = repo.findById(1L).orElse(null);
            assertNotNull(encontrado);
            assertEquals(50.0, encontrado.getPrecoServico());
        }
}
