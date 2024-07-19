import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/team_services.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/widgets/custom_toast.dart';

class AddTeamPage extends StatefulWidget {
  const AddTeamPage({super.key});

  @override
  AddTeamPageState createState() => AddTeamPageState();
}

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

      debugPrint('Team data: $teamData'); // Ajout d'un log pour les données de l'équipe

      try {
        final teamService = Provider.of<ITeamService>(context, listen: false);
        await teamService.createTeam(teamData);
        if (!mounted) return;
        showCustomToast(
            AppLocalizations.of(context).teamCreatedSuccessfully, Colors.green);
        if (!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        showCustomToast(
            AppLocalizations.of(context).failedToCreateTeam(e.toString()),
            Colors.red);
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
    AppLocalizations l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.addTeam)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l.name),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l.nameIsRequired;
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text(l.private),
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
                child: Text(l.createTeam),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
