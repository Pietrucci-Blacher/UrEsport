import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/l10n/app_localizations.dart';

import 'package:uresport/core/services/cache_service.dart';

class AddTournamentPage extends StatefulWidget {
  const AddTournamentPage({super.key});

  @override
  AddTournamentPageState createState() => AddTournamentPageState();
}

class AddTournamentPageState extends State<AddTournamentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _imageController = TextEditingController();
  final _gameIdController = TextEditingController();
  final _nbPlayerController = TextEditingController();
  final TextEditingController _startDateTimeController = TextEditingController();
  final TextEditingController _endDateTimeController = TextEditingController();
  final Dio _dio = Dio();
  bool _isPrivate = false;
  final CacheService _cacheService = CacheService.instance;

  final DateFormat _apiDateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  final DateFormat _displayDateFormat = DateFormat("dd-MM-yyyy HH:mm");

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  String _formatDateToUtcWithoutMilliseconds(DateTime dateTime) {
    return _apiDateFormat.format(dateTime.toUtc());
  }

  void _updateDateTimeField(bool isStartDate) {
    setState(() {
      if (isStartDate) {
        _startDateTimeController.text = _startDateTime != null ? _displayDateFormat.format(_startDateTime!) : '';
      } else {
        _endDateTimeController.text = _endDateTime != null ? _displayDateFormat.format(_endDateTime!) : '';
      }
    });
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartDate) async {
    AppLocalizations l = AppLocalizations.of(context);
    DateTime today = DateTime.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isStartDate ? l.selectStartDate : l.selectEndDate),
          content: SizedBox(
            height: 300,
            width: 300,
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.single,
              minDate: isStartDate
                  ? today
                  : (_startDateTime != null ? _startDateTime!.add(Duration(minutes: 1)) : today),
              showActionButtons: true,
              onSubmit: (Object? value) {
                if (value is DateTime) {
                  if (isStartDate) {
                    // Update start date with selected time
                    _startDateTime = value;
                    if (_endDateTime != null && _endDateTime!.isBefore(_startDateTime!.add(Duration(minutes: 1)))) {
                      // If end date is before start date + 1 minute, adjust it
                      _endDateTime = _startDateTime!.add(Duration(minutes: 1));
                      _endDateTimeController.text = _displayDateFormat.format(_endDateTime!);
                    }
                  } else {
                    // Update end date with selected time
                    _endDateTime = value;
                  }

                  // Update the text fields
                  _updateDateTimeField(isStartDate);
                  Navigator.pop(context);
                }
              },
              onCancel: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );

    // After selecting the date, show time picker
    if ((isStartDate && _startDateTime != null && context.mounted) ||
        (!isStartDate && _endDateTime != null && context.mounted)) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          if (isStartDate) {
            // Update start date with selected time
            _startDateTime = DateTime(
              _startDateTime!.year,
              _startDateTime!.month,
              _startDateTime!.day,
              time.hour,
              time.minute,
            );

            if (_endDateTime != null && _endDateTime!.isBefore(_startDateTime!.add(Duration(minutes: 1)))) {
              // If end date is before start date + 1 minute, adjust it
              _endDateTime = _startDateTime!.add(Duration(minutes: 1));
              _endDateTimeController.text = _displayDateFormat.format(_endDateTime!);
            }
          } else {
            // Update end date with selected time
            _endDateTime = DateTime(
              _endDateTime!.year,
              _endDateTime!.month,
              _endDateTime!.day,
              time.hour,
              time.minute,
            );

            // Check if end date is before start date, adjust if necessary
            if (_startDateTime != null && _endDateTime != null && _endDateTime!.isBefore(_startDateTime!)) {
              _endDateTime = _startDateTime!.add(Duration(minutes: 1)); // Set end date to one minute after start date
              _endDateTimeController.text = _displayDateFormat.format(_endDateTime!);
            }
          }

          // Update the text fields
          _updateDateTimeField(isStartDate);
        });
      }
    }
  }

  Future<void> _saveTournament() async {
    AppLocalizations l = AppLocalizations.of(context);
    if (_formKey.currentState!.validate() &&
        _startDateTime != null &&
        _endDateTime != null) {
      final newTournament = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'start_date': _apiDateFormat.format(_startDateTime!), // Use API format for start date
        'end_date': _apiDateFormat.format(_endDateTime!),     // Use API format for end date
        'location': _locationController.text.isNotEmpty
            ? _locationController.text
            : null,
        'latitude': _latitudeController.text.isNotEmpty
            ? double.tryParse(_latitudeController.text)
            : null,
        'longitude': _longitudeController.text.isNotEmpty
            ? double.tryParse(_longitudeController.text)
            : null,
        'private': _isPrivate,
        'game_id': int.tryParse(_gameIdController.text) ?? 0,
        'nb_player': int.tryParse(_nbPlayerController.text) ?? 0,
      };

      if (kDebugMode) {
        print('Sending data: $newTournament');
      }

      try {
        final token = await _cacheService.getString('token');
        if (token == null) throw Exception('No token found');
        final response = await _dio.post(
          '${dotenv.env['API_ENDPOINT']}/tournaments/',
          data: newTournament,
          options: Options(headers: {
            'Authorization': token,
          }),
        );

        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
          print('Response data: ${response.data}');
        }

        if (!mounted) return;

        if (response.statusCode == 201) {
          _handleSuccessfulResponse();
        } else {
          _showAlertDialog('${l.errorAddingTournament}: ${response.statusMessage}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Exception: $e');
        }
        if (!mounted) return;
        _showAlertDialog('${l.errorAddingTournament}: $e');
      }
    } else {
      _showAlertDialog(l.pleaseFillRequiredFields);
    }
  }


  void _handleSuccessfulResponse() {
    AppLocalizations l = AppLocalizations.of(context);
    Navigator.of(context).pop(true);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.tournamentAdded)));
    context.read<DashboardBloc>().add(FetchTournaments());
  }

  void _showAlertDialog(String message) {
    if (kDebugMode) {
      print(message);
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _imageController.dispose();
    _gameIdController.dispose();
    _nbPlayerController.dispose();
    _startDateTimeController.dispose();
    _endDateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.addTournament, style: const TextStyle(fontSize: 24)),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: l.name),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l.pleaseEnterTournamentName;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: l.description),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l.pleaseEnterTournamentDescription;
                        }
                        return null;
                      },
                    ),
                    GestureDetector(
                      onTap: () => _selectDateTime(context, true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _startDateTimeController,
                          decoration: InputDecoration(
                            labelText: l.startDateTime,
                            hintText: _startDateTime != null
                                ? _displayDateFormat.format(_startDateTime!)
                                : '',
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _selectDateTime(context, false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _endDateTimeController,
                          decoration: InputDecoration(
                            labelText: l.endDateTime,
                            hintText: _endDateTime != null
                                ? _displayDateFormat.format(_endDateTime!)
                                : '',
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                    TextFormField(
                      controller: _latitudeController,
                      decoration: InputDecoration(labelText: l.latitude),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: _longitudeController,
                      decoration: InputDecoration(labelText: l.longitude),
                      keyboardType: TextInputType.number,
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
                    TextFormField(
                      controller: _gameIdController,
                      decoration: InputDecoration(labelText: l.gameId),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l.pleaseEnterGameId;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _nbPlayerController,
                      decoration: InputDecoration(labelText: l.numberOfPlayers),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l.pleaseEnterNumberOfPlayers;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l.cancel),
                ),
                ElevatedButton(
                  onPressed: _saveTournament,
                  child: Text(l.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
