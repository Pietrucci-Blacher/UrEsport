import 'package:flutter/material.dart';

class LocaleSwitcher extends StatelessWidget {
  final Function(Locale) onLocaleChanged;

  const LocaleSwitcher({super.key, required this.onLocaleChanged});

  void _showLocaleDialog(BuildContext context) {
    const List<Locale> locales = [
      Locale('en', ''),
      Locale('es', ''),
      Locale('fr', ''),
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: locales.map((Locale locale) {
              return ListTile(
                leading: _getFlag(locale),
                title: Text(_getLanguageName(locale)),
                onTap: () {
                  onLocaleChanged(locale);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _getFlag(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return const Text('🇺🇸');
      case 'es':
        return const Text('🇪🇸');
      case 'fr':
        return const Text('🇫🇷');
      default:
        return const Text('🌐');
    }
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      default:
        return locale.languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.language),
      onPressed: () => _showLocaleDialog(context),
    );
  }
}
