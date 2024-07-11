import 'package:flutter/material.dart';
import 'package:uresport/bracket/screens/custom_schedule.dart';

class MatchDetailsPage extends StatelessWidget {
  final Match match;

  const MatchDetailsPage({required this.match, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Match between ${match.team1} and ${match.team2}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTeamHeader(match.team1, match.team2),
                      const Divider(thickness: 2),
                      _buildStatColumn('Date', match.date),
                      _buildStatColumn('Time', match.time),
                      const Divider(thickness: 2),
                      _buildCustomScoreRow(
                          'Score', '0', '0'), // Ligne personnalisée
                      _buildVerticalDivider(),
                      _buildStatRow('Goals', '0', '0'),
                      _buildVerticalDivider(),
                      _buildStatRow('Total Shots', '0', '0'),
                      _buildVerticalDivider(),
                      _buildStatRow('Shots on Target', '0', '0'),
                      _buildVerticalDivider(),
                      _buildStatRow('Possession', '50%', '50%'),
                      _buildVerticalDivider(),
                      _buildStatRow('Fouls', '0', '0'),
                      _buildVerticalDivider(),
                      _buildStatRow('Yellow Cards', '0', '0'),
                      _buildVerticalDivider(),
                      _buildStatRow('Red Cards', '0', '0'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamHeader(String team1, String team2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                team1,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  'A',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const Expanded(
          child: Text(
            'VS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                team2,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const CircleAvatar(
                backgroundColor: Colors.red,
                child: Text(
                  'B',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn(String statName, String statValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            statName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            statValue,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String statName, String statValue1, String statValue2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              statValue1,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey,
          ),
          Expanded(
            child: Text(
              statName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 1,
            height: 24,
            color: Colors.grey,
          ),
          Expanded(
            child: Text(
              statValue2,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour créer la ligne personnalisée du score
  Widget _buildCustomScoreRow(
      String statName, String statValue1, String statValue2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.sports_soccer, color: Colors.blue),
                const SizedBox(height: 5),
                Text(
                  statValue1,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  statName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey,
          ),
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.sports_soccer, color: Colors.red),
                const SizedBox(height: 5),
                Text(
                  statValue2,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Divider(thickness: 1, color: Colors.grey),
    );
  }
}
