import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:tp2/viewModel/taskViewModel.dart';
import 'modele/task.dart';

class AddTaskForm extends StatefulWidget {
  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Center(
        child: Column(
          children: [
            FormBuilder(
                key: _formKey,
                child: Column(children: [
                  FormBuilderTextField(
                    name: 'tache',
                    decoration:
                        const InputDecoration(labelText: "Titre de la tache"),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                    onChanged: (val) {
                      print(val); // Print the text value write into TextField
                    },
                  ),
                  FormBuilderCheckboxGroup<String>(
                    name: "tags",
                    decoration: const InputDecoration(labelText: 'Tags'),
                    options: [
                      FormBuilderFieldOption(
                          value: 'tag 0', child: Text("Tag 0")),
                      FormBuilderFieldOption(
                          value: 'tag 1', child: Text("Tag 1")),
                      FormBuilderFieldOption(
                          value: 'tag 2', child: Text("Tag 2")),
                      FormBuilderFieldOption(
                          value: 'tag 3', child: Text("Tag 3")),
                      FormBuilderFieldOption(
                          value: 'tag 4', child: Text("Tag 4")),
                      FormBuilderFieldOption(
                          value: 'tag 5', child: Text("Tag 5"))
                    ],
                    validator: FormBuilderValidators.minLength(1,
                        errorText: "Selectionnez au moins un tag"),
                  ),
                  FormBuilderTextField(
                    name: 'nbHours',
                    decoration:
                        const InputDecoration(labelText: "Nombre Heure"),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.integer()
                    ]),
                    onChanged: (val) {
                      print(val); // Print the text value write into TextField
                    },
                  ),
                  FormBuilderTextField(
                    name: 'difficulte',
                    decoration:
                        const InputDecoration(labelText: "Niveau difficulte"),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.integer()
                    ]),
                    onChanged: (val) {
                      print(val); // Print the text value write into TextField
                    },
                  ),
                  FormBuilderTextField(
                    name: 'description',
                    decoration: const InputDecoration(labelText: "description"),
                    validator: FormBuilderValidators.compose(
                        [FormBuilderValidators.required()]),
                  )
                ])),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlue,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<TaskViewModel>().addTask(Task.createTask(
                    _formKey.currentState?.fields['tache']?.value,
                    _formKey.currentState?.fields['tags']?.value,
                    int.tryParse(_formKey.currentState?.fields['nbHours']?.value)!,
                    int.tryParse(_formKey.currentState?.fields['difficulte']?.value)!,
                    _formKey.currentState?.fields['description']?.value
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Tache ajouté"))
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }
}
