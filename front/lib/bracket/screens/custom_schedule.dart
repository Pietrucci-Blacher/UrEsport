import 'package:flutter/material.dart';
import 'package:uresport/bracket/screens/match_details_page.dart';

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
      team1: 'TEAM C',
      team2: 'TEAM D',
      date: '10/05',
      time: '06:30',
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
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: match.team1Image != null
                                      ? AssetImage(match.team1Image!)
                                      : null,
                                  radius: 20,
                                  backgroundColor: Colors.grey,
                                  child: match.team1Image == null
                                      ? const Icon(Icons.sports_soccer, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  match.team1,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(
                            child: Text(
                              '0 - 0',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  match.team2,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                CircleAvatar(
                                  backgroundImage: match.team2Image != null
                                      ? AssetImage(match.team2Image!)
                                      : null,
                                  radius: 20,
                                  backgroundColor: Colors.grey,
                                  child: match.team2Image == null
                                      ? const Icon(Icons.sports_soccer, color: Colors.white)
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                match.date,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.white, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                match.time,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
          );
        },
      ),
    );
  }
}
