import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/shared/map/map.dart';
import 'package:uresport/tournament/bloc/tournament_bloc.dart';
import 'package:uresport/tournament/bloc/tournament_event.dart';
import 'package:uresport/tournament/bloc/tournament_state.dart';
import 'package:uresport/tournament/screens/tournament_details_screen.dart';
import 'package:uresport/widgets/gradient_icon.dart';
import 'package:uresport/core/models/user.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:uresport/l10n/app_localizations.dart';

import 'package:uresport/tournament/screens/add_tournament.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});

  @override
  TournamentScreenState createState() => TournamentScreenState();
}

class TournamentScreenState extends State<TournamentScreen> {
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

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations l = AppLocalizations.of(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: l.listAllTournaments),
              Tab(text: l.listMyTournaments),
              Tab(text: l.listMyTournamentsJoined),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTournamentList(context, false),
            _buildTournamentList(context, true),
            _buildTeamList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamList(BuildContext context) {
    if (_currentUser == null) {
      AppLocalizations l = AppLocalizations.of(context);
      return Center(child: Text(l.mustBeLoggedIn));
    }

    return FutureBuilder(
      future: _loadUserTeams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          debugPrint('Error in FutureBuilder: ${snapshot.error}');
          return const Center(child: Text('Failed to load user teams'));
        } else if (!snapshot.hasData || (snapshot.data as List<Team>).isEmpty) {
          return const Center(child: Text('No teams found for the user'));
        } else {
          final teams = snapshot.data as List<Team>;
          debugPrint('Teams data: $teams');
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return ExpansionTile(
                title: Text(team.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text('Members: ${team.members.length} | Tournaments: ${team.tournaments.length}', style: TextStyle(fontSize: 14, color: Colors.grey)),
                children: team.tournaments.map((tournamentJson) {
                  Tournament tournament = Tournament.fromJson(tournamentJson);
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10.0),
                      leading: Image.network(tournament.image, width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(tournament.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start: ${DateFormat.yMMMd().format(tournament.startDate)}', style: TextStyle(fontSize: 14)),
                          Text('End: ${DateFormat.yMMMd().format(tournament.endDate)}', style: TextStyle(fontSize: 14)),
                          Text(tournament.description, style: TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TournamentDetailsScreen(tournament: tournament),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            },
          );
        }
      },
    );
  }

  Future<List<Team>> _loadUserTeams() async {
    if (_currentUser == null) {
      throw Exception('User is not logged in');
    }

    final userId = _currentUser!.id;
    final url = '${dotenv.env['API_ENDPOINT']}/teams/user/$userId';
    debugPrint('Fetching user teams from $url');

    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final data = response.data as List;
        debugPrint('Received user teams: $data');
        return data.map((json) => Team.fromJson(json)).toList();
      } else {
        debugPrint('Failed to load user teams with status code: ${response.statusCode}');
        throw Exception('Failed to load user teams');
      }
    } catch (e) {
      debugPrint('Error fetching user teams: $e');
      throw Exception('Failed to load user teams');
    }
  }

  Widget _buildTournamentList(BuildContext context, bool isOwner) {
    var ownerId = isOwner ? _currentUser?.id : null;
    AppLocalizations l = AppLocalizations.of(context);

    if (isOwner && ownerId == null) {
      return Center(child: Text(l.mustBeLoggedIn));
    }

    return BlocProvider(
      create: (context) => TournamentBloc(context.read<ITournamentService>())
        ..add(LoadTournaments(ownerId: ownerId)),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<TournamentBloc>().add(LoadTournaments(ownerId: ownerId));
          },
          child: BlocBuilder<TournamentBloc, TournamentState>(
            builder: (context, state) {
              if (state is TournamentInitial) {
                context.read<TournamentBloc>().add(LoadTournaments(ownerId: ownerId));
                return const Center(child: CircularProgressIndicator());
              } else if (state is TournamentLoadInProgress) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TournamentLoadSuccess) {
                return Stack(
                  children: [
                    ListView.builder(
                      itemCount: state.tournaments.length,
                      itemBuilder: (context, index) {
                        final tournament = state.tournaments[index];
                        return _buildTournamentCard(context, tournament);
                      },
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FloatingActionButton(
                              heroTag: 'map-fab',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TournamentMapWidget(tournaments: state.tournaments),
                                  ),
                                );
                              },
                              child: const Icon(Icons.map),
                            ),
                            const SizedBox(height: 16),
                            if (_currentUser != null)
                              FloatingActionButton(
                                heroTag: 'create tournament',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddTournamentPage(),
                                    ),
                                  );
                                },
                                child: const Icon(Icons.add),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (state is TournamentLoadFailure) {
                return const Center(child: Text('Failed to load tournaments'));
              }
              return const Center(child: Text('Unknown state'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTournamentCard(BuildContext context, Tournament tournament) {
    final DateFormat dateFormat = DateFormat.yMMMd(Localizations.localeOf(context).toString());

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TournamentDetailsScreen(tournament: tournament),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                tournament.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          tournament.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (tournament.isPrivate)
                        const Icon(
                          Icons.lock,
                          color: Colors.red,
                        )
                      else
                        const Icon(
                          Icons.lock_open,
                          color: Colors.green,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tournament.description,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.grey),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    tournament.location,
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.videogame_asset, color: Colors.grey),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Game: ${tournament.game.name}',
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.grey),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Start: ${dateFormat.format(tournament.startDate)}',
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.grey),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'End: ${dateFormat.format(tournament.endDate)}',
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.person, color: Colors.grey),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'Nombre joueurs par teams: ${tournament.nbPlayers}',
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              GradientIcon(
                                icon: Icons.local_fire_department,
                                size: 30.0,
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.red,
                                    Colors.red.withOpacity(0.7),
                                    Colors.orange,
                                    Colors.yellow,
                                    Colors.green,
                                  ],
                                  stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${tournament.upvotes}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
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
                            child: const Text('View Details'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
