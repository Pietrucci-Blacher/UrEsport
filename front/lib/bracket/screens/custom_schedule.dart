import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Match {
  final String team1;
  final String team2;
  final String date;
  final String time;
  final String? team1Image;
  final String? team2Image;

  const Match({
    required this.team1,
    required this.team2,
    required this.date,
    required this.time,
    this.team1Image,
    this.team2Image,
  });
}

class CustomSchedulePage extends StatelessWidget {
  const CustomSchedulePage({super.key});

  final List<Match> matches = const [
    Match(
      team1: 'TEAM A',
      team2: 'TEAM B',
      date: '10/03',
      time: '05:30',
      team1Image: 'assets/team_a.png',
      team2Image: 'assets/team_b.png',
    ),
    Match(
      team1: 'TEAM 1',
      team2: 'TEAM 2',
      date: '10/03',
      time: '10:00',
      team1Image: 'assets/team_a.png',
      team2Image: 'assets/team_b.png',
    ),
    Match(
      team1: 'TEAM C',
      team2: 'TEAM D',
      date: '10/05',
      time: '06:30',
      team1Image: 'assets/team_c.png',
      team2Image: 'assets/team_d.png',
    ),
    Match(
      team1: 'TEAM 3',
      team2: 'TEAM 4',
      date: '10/05',
      time: '03:00',
      team1Image: 'assets/team_c.png',
      team2Image: 'assets/team_d.png',
    ),
    Match(
      team1: 'TEAM E',
      team2: 'TEAM F',
      date: '10/07',
      time: '03:30',
      team1Image: 'assets/team_e.png',
      team2Image: 'assets/team_f.png',
    ),
    Match(
      team1: 'TEAM G',
      team2: 'TEAM H',
      date: '10/09',
      time: '07:30',
      team1Image: 'assets/team_g.png',
      team2Image: 'assets/team_h.png',
    ),
    Match(
      team1: 'TEAM I',
      team2: 'TEAM J',
      date: '10/10',
      time: '08:30',
      team1Image: 'assets/team_i.png',
      team2Image: 'assets/team_j.png',
    ),
  ];

  DateTime _parseDateTime(String date, String time) {
    final dateFormat = DateFormat('MM/dd');
    final timeFormat = DateFormat('HH:mm');
    DateTime parsedDate = dateFormat.parse(date);
    DateTime parsedTime = timeFormat.parse(time);
    return DateTime(parsedDate.year, parsedDate.month, parsedDate.day,
        parsedTime.hour, parsedTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    // Créer une copie mutable de la liste des matchs
    List<Match> sortedMatches = List.from(matches);

    // Convertir les dates et trier les matchs par date et heure
    sortedMatches.sort((a, b) {
      DateTime dateTimeA = _parseDateTime(a.date, a.time);
      DateTime dateTimeB = _parseDateTime(b.date, b.time);
      return dateTimeA.compareTo(dateTimeB);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Schedule'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: sortedMatches.length,
        itemBuilder: (context, index) {
          final match = sortedMatches[index];
          bool isNewDate = index == 0 ||
              _parseDateTime(match.date, match.time).day !=
                  _parseDateTime(sortedMatches[index - 1].date,
                          sortedMatches[index - 1].time)
                      .day;

          // Formatter la date dans le format souhaité
          final DateTime matchDate = _parseDateTime(match.date, match.time);
          final String formattedDate = DateFormat('EEEE - d MMMM', 'fr_FR')
              .format(matchDate)
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
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => MatchDetailsPage(match: match),
                  //     ),
                  //   );
                  // },
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
                              Expanded(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: match.team1Image != null
                                          ? AssetImage(match.team1Image!)
                                          : null,
                                      radius: 20,
                                      backgroundColor: Colors.grey.shade200,
                                      child: match.team1Image == null
                                          ? const Icon(Icons.sports_soccer,
                                              color: Colors.black)
                                          : null,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      match.team1,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                'VS',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      match.team2,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    CircleAvatar(
                                      backgroundImage: match.team2Image != null
                                          ? AssetImage(match.team2Image!)
                                          : null,
                                      radius: 20,
                                      backgroundColor: Colors.grey.shade200,
                                      child: match.team2Image == null
                                          ? const Icon(Icons.sports_soccer,
                                              color: Colors.black)
                                          : null,
                                    ),
                                  ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      color: Colors.black, size: 16),
                                  const SizedBox(width: 5),
                                  Text(
                                    match.time,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Ajouter une barre de séparation uniquement si le prochain match a une date différente
              if (index < sortedMatches.length - 1 &&
                  _parseDateTime(sortedMatches[index].date,
                              sortedMatches[index].time)
                          .day !=
                      _parseDateTime(sortedMatches[index + 1].date,
                              sortedMatches[index + 1].time)
                          .day)
                const Divider(thickness: 1, color: Colors.grey),
            ],
          );
        },
      ),
    );
  }
}
