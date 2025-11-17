import 'package:flutter/material.dart';
import 'package:hora_do_bicho/models/agendamento_response.dart';

class AgendamentoListItem extends StatelessWidget {
  final AgendamentoResponse agendamento;
  final VoidCallback? onTap;

  const AgendamentoListItem({
    super.key,
    required this.agendamento,
    this.onTap,
  });

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: "$label:  ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = agendamento.dataHoraAgendamento;
    final hora = TimeOfDay.fromDateTime(data);

    final servicosStr =
        agendamento.servicos.map((s) => s.nomeServico).join(', ');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 6
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${data.day.toString().padLeft(2, '0')}/'
              '${data.month.toString().padLeft(2, '0')} • '
              '${hora.format(context)}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            _info("Cliente", agendamento.cliente.nomeCliente!),
            _info("Pet", agendamento.pet.nomePet),
            _info("Funcionário", agendamento.funcionario.nomeFuncionario),
            _info("Serviços", servicosStr),
            // pegar preço dps
            // _info("Preço Total", agendamento),

            const SizedBox(height: 4),

            _info("Status", agendamento.statusAgendamento.name),
          ],
        ),
      ),
    );
  }
}
