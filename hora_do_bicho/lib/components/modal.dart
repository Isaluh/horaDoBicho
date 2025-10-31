import 'package:flutter/material.dart';
import 'package:hora_do_bicho/components/botoes.dart';

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
        fields = ['nomePet', 'idadePet', 'especiePet', 'racaPet'];
        break;
      case FormType.funcionario:
        fields = ['nome', 'telefone'];
        break;
      case FormType.servico:
        fields = ['titulo', 'descricao', 'preco'];
        break;
    }

    for (var field in fields) {
      _controllers[field] = TextEditingController(
        text: widget.initialData != null
            ? widget.initialData![field]?.toString() ?? ''
            : '',
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
      final data = {
        for (var entry in _controllers.entries) entry.key: entry.value.text,
      };
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      title: Text('$title $tipoTexto', style: TextStyle(fontSize: 20)),
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
                    labelText: entry.key
                        .replaceAll('Pet', '') 
                        .replaceFirstMapped(
                          RegExp(r'^[a-z]'),
                          (m) => m.group(0)!.toUpperCase(),
                        ),
                    floatingLabelStyle: const TextStyle(
                      color: Color(0xFF2596be),
                    ),
                    labelStyle: const TextStyle(fontSize: 14),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF2596be)),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                  keyboardType: entry.key == 'preco'
                      ? TextInputType.number
                      : TextInputType.text,
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
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButtonComponent(
          onPressed: _handleSave,
          text: isEdit ? 'Salvar' : 'Criar',
          color: const Color(0xFF98E6F6),
          textColor: Colors.black,
        ),
      ],
    );
  }
}
