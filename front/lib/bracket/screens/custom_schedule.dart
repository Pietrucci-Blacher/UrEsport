import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/game_service.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/tournament/screens/tournament_details_screen.dart';
import 'package:uresport/l10n/app_localizations.dart';

class CustomSchedulePage extends StatefulWidget {
  final GameService gameService;
  final TournamentService tournamentService;

  const CustomSchedulePage(
      {super.key, required this.gameService, required this.tournamentService});

  @override
  CustomSchedulePageState createState() => CustomSchedulePageState();
}

class CustomSchedulePageState extends State<CustomSchedulePage> {
  List<Tournament> tournaments = [];
  bool isLoading = true;
  DateTime? selectedDate;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    fetchTournaments();
  }

  Future<void> fetchTournaments() async {
    try {
      List<Tournament> fetchedTournaments =
          await widget.tournamentService.fetchTournaments();
      setState(() {
        tournaments = fetchedTournaments;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedFilter = 'Date';
      });
    }
  }

  void _filterChanged(String? filter) {
    setState(() {
      selectedFilter = filter ?? 'All';
      if (selectedFilter == 'Now') {
        selectedDate = DateTime.now();
      } else if (selectedFilter == 'All') {
        selectedDate = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);
    // Récupérer la locale actuelle pour formater les dates
    String locale = Localizations.localeOf(context).languageCode;
    List<Tournament> filteredTournaments = selectedDate == null
        ? tournaments
        : tournaments.where((tournament) {
            return DateFormat('yyyy-MM-dd').format(tournament.startDate) ==
                DateFormat('yyyy-MM-dd').format(selectedDate!);
          }).toList();

    // Trier les tournois par date de début
    filteredTournaments.sort((a, b) => a.startDate.compareTo(b.startDate));

    return Scaffold(
      appBar: AppBar(
        title: Text(l.tournamentSchedule),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedFilter,
                icon: const Icon(Icons.filter_list, color: Colors.white),
                items: [
                  DropdownMenuItem(
                    value: 'All',
                    child: Row(
                      children: [
                        const Icon(Icons.list, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(l.allTournaments),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Now',
                    child: Row(
                      children: [
                        const Icon(Icons.today, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(l.nowTournaments),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Date',
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.orange),
                        const SizedBox(width: 8),
                        Text(l.selectDate),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value == 'Date') {
                    _selectDate(context);
                  } else {
                    _filterChanged(value);
                  }
                },
                dropdownColor: Colors.white,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredTournaments.isEmpty
              ? Center(
                  child: Text(
                    l.noTournamentForDate,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: filteredTournaments.length,
                  itemBuilder: (context, index) {
                    final tournament = filteredTournaments[index];
                    bool isNewDate = index == 0 ||
                        filteredTournaments[index].startDate.day !=
                            filteredTournaments[index - 1].startDate.day;

                    // Formatter la date en fonction de la locale
                    final String formattedDate =
                        DateFormat('EEEE - d MMMM', locale)
                            .format(tournament.startDate)
                            .toUpperCase();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isNewDate)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            child: Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TournamentDetailsScreen(
                                    tournament: tournament,
                                    game: tournament.game,
                                  ),
                                ),
                              );
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              AssetImage(tournament.image),
                                          radius: 20,
                                          backgroundColor: Colors.grey.shade200,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            tournament.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            color: Colors.black, size: 16),
                                        const SizedBox(width: 5),
                                        Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format(tournament.startDate),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            color: Colors.black, size: 16),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            tournament.location,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(Icons.videogame_asset,
                                            color: Colors.black, size: 16),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            tournament.game.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (index < filteredTournaments.length - 1 &&
                            filteredTournaments[index].startDate.day !=
                                filteredTournaments[index + 1].startDate.day)
                          const Divider(thickness: 1, color: Colors.grey),
                      ],
                    );
                  },
                ),
    );
  }
}

void main() async {
  await dotenv.load();
  final dio = Dio();
  final gameService = GameService(dio);
  final tournamentService = TournamentService(dio);

  runApp(MaterialApp(
    home: CustomSchedulePage(
      gameService: gameService,
      tournamentService: tournamentService,
    ),
  ));
}
