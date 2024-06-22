import 'package:flutter/material.dart';
import 'package:uresport/bracket/screens/match_details_page.dart';

class Match {
  final String team1;
  final String team2;
  final String date;
  final String time;

  const Match({required this.team1, required this.team2, required this.date, required this.time});
}

class CustomSchedulePage extends StatelessWidget {
  const CustomSchedulePage({super.key});

  final List<Match> matches = const [
    Match(team1: 'TEAM A', team2: 'TEAM B', date: '10/03', time: '05:30'),
    Match(team1: 'TEAM C', team2: 'TEAM D', date: '10/05', time: '06:30'),
    Match(team1: 'TEAM E', team2: 'TEAM F', date: '10/07', time: '03:30'),
    Match(team1: 'TEAM G', team2: 'TEAM H', date: '10/09', time: '07:30'),
    Match(team1: 'TEAM I', team2: 'TEAM J', date: '10/10', time: '08:30'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Schedule'),
      ),
      body: ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MatchDetailsPage(match: match),
                  ),
                );
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2D005B), Color(0xFF000000), Color(0xFFD31D1D)],
                      stops: [0.2, 0.6, 1.0],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          match.team1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          match.date,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Text(
                          'VS',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          match.time,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          match.team2,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
