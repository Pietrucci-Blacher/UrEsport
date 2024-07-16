import 'package:uresport/core/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
// import 'package:uresport/bracket/screens/custom_schedule.dart' as custom_schedule;
import 'package:uresport/core/models/match.dart';
import 'package:uresport/core/websocket/websocket.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/match_service.dart';

class MatchDetailsPage extends StatefulWidget  {
  final Match match;

  const MatchDetailsPage({required this.match, super.key});

  @override
  MatchDetailsPageState createState() => MatchDetailsPageState();
}

class MatchDetailsPageState extends State<MatchDetailsPage>  {
  final Websocket ws = Websocket.getInstance();
  late Match match;
  User? _currentUser;

  Future<void> _loadCurrentUser() async {
    final authService = Provider.of<IAuthService>(context, listen: false);
    try {
      final user = await authService.getUser();
      if (!mounted) return;
      setState(() {
        _currentUser = user;
      });
    } catch (e) {
      debugPrint('Error loading current user: $e');
    }
  }

  void websocket() {
    ws.on('match:update', (socket, data) async {
      setState(() {
        match = Match.fromJson(data);
      });
    });

    ws.emit('tournament:add-to-room', {
      'tournament_id': widget.match.tournamentId,
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    websocket();
  }

  @override
  Widget build(BuildContext context) {
    match = widget.match;
    var isTeamOwner = _currentUser?.id == match.team1?.ownerId || _currentUser?.id == match.team2?.ownerId;
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
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTeamHeader(match.team1?.name ?? '', match.team2?.name ?? ''),
                      // const Divider(thickness: 2),
                      // _buildStatColumn('Date', match.date),
                      // _buildStatColumn('Time', match.time),
                      const Divider(thickness: 2),
                      _buildCustomScoreRow(
                          'Score', match.score1.toString(), match.score2.toString()),
                      const Divider(thickness: 2),
                      if (isTeamOwner)
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _openScoreModal();
                            },
                            child: const Text('Enter le score'),
                          ),
                        )
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

  void _openScoreModal() {
    final teamService = Provider.of<IMatchService>(context, listen: false);
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Entrer the score'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final updatedMatch = await teamService.setScore(
                      match.id,
                      match.team1Id ?? 0,
                      1,
                    );
                    setState(() {
                      match = updatedMatch;
                    });
                  },
                  child: const Text('1'),
                ),
              ],
            ),
          ),
        );
      },
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

  // Widget _buildStatColumn(String statName, String statValue) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           statName,
  //           style: const TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         Text(
  //           statValue,
  //           style: const TextStyle(
  //             fontSize: 16,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildStatRow(String statName, String statValue1, String statValue2) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Expanded(
  //           child: Text(
  //             statValue1,
  //             style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         Container(
  //           width: 1,
  //           height: 24,
  //           color: Colors.grey,
  //         ),
  //         Expanded(
  //           child: Text(
  //             statName,
  //             style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //         Container(
  //           width: 1,
  //           height: 24,
  //           color: Colors.grey,
  //         ),
  //         Expanded(
  //           child: Text(
  //             statValue2,
  //             style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

  // Widget _buildVerticalDivider() {
  //   return const Padding(
  //     padding: EdgeInsets.symmetric(vertical: 4.0),
  //     child: Divider(thickness: 1, color: Colors.grey),
  //   );
  // }
}
