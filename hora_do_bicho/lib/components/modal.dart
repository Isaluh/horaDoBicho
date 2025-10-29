import 'package:flutter/material.dart';

enum FormType { pet, funcionario, servico }
enum FormMode { criar, editar }

class CustomFormModal extends StatefulWidget {
  final FormType formType;
  final FormMode formMode;
  final Function(Map<String, dynamic>) onSave;
  final Map<String, dynamic>? initialData;

  const CustomFormModal({
    super.key,
    required this.formType,
    required this.formMode,
    required this.onSave,
    this.initialData,
  });

  @override
  State<CustomFormModal> createState() => _CustomFormModalState();
}

class _CustomFormModalState extends State<CustomFormModal> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _setupControllers();
  }

  void _setupControllers() {
    List<String> fields;

    switch (widget.formType) {
      case FormType.pet:
        fields = ['nome', 'idade', 'raca', 'especie'];
        break;
      case FormType.funcionario:
        fields = ['nome', 'telefone'];
        break;
      case FormType.servico:
        fields = ['titulo', 'descricao', 'preco'];
        break;
    }

    // Cria os controllers
    for (var field in fields) {
      _controllers[field] = TextEditingController(
        text: widget.initialData != null ? widget.initialData![field]?.toString() ?? '' : '',
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final data = { for (var entry in _controllers.entries) entry.key: entry.value.text };
      widget.onSave(data);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.formMode == FormMode.editar;
    final title = isEdit ? 'Editar' : 'Novo';

    String tipoTexto;
    switch (widget.formType) {
      case FormType.pet:
        tipoTexto = 'Pet';
        break;
      case FormType.funcionario:
        tipoTexto = 'Funcionário';
        break;
      case FormType.servico:
        tipoTexto = 'Serviço';
        break;
    }

    return AlertDialog(
      title: Text('$title $tipoTexto'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _controllers.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: TextFormField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    labelText: entry.key[0].toUpperCase() + entry.key.substring(1),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: entry.key == 'preco' ? TextInputType.number : TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Preencha o campo ${entry.key}';
                    }
                    return null;
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF98E6F6)),
          child: Text(isEdit ? 'Salvar' : 'Criar'),
        ),
      ],
    );
  }
}
