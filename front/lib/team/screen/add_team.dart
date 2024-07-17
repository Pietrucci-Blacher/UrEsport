import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/team_services.dart';
import 'package:uresport/widgets/custom_toast.dart';

class AddTeamPage extends StatefulWidget {
  const AddTeamPage({super.key});

  @override AddTeamPageState createState() => AddTeamPageState();}

class AddTeamPageState extends State<AddTeamPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _isPrivate = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final teamData = {
        'name': _nameController.text,
        'private': _isPrivate,
      };

      try {
        final teamService = Provider.of<ITeamService>(context, listen: false);
        await teamService.createTeam(teamData);
        showCustomToast('Équipe créée avec succès', Colors.green);
        if(!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        showCustomToast('Erreur lors de la création de l\'équipe: $e', Colors.red);
      }
    }
  }

  void showCustomToast(String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomToast(
        message: message,
        backgroundColor: backgroundColor,
        onClose: () {
          overlayEntry.remove();
        },
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Team')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Private'),
                value: _isPrivate,
                onChanged: (bool value) {
                  setState(() {
                    _isPrivate = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Team'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
