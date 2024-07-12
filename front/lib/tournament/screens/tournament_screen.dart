import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      if (kDebugMode) {
        debugPrint('Error loading current user: $e');
      }
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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: l.listAllTournaments),
              Tab(text: l.listMyTournaments),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTournamentList(context, false),
            _buildTournamentList(context, true),
          ],
        ),
      ),
    );
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
            context
                .read<TournamentBloc>()
                .add(LoadTournaments(ownerId: ownerId));
          },
          child: BlocBuilder<TournamentBloc, TournamentState>(
            builder: (context, state) {
              if (state is TournamentInitial) {
                context
                    .read<TournamentBloc>()
                    .add(LoadTournaments(ownerId: ownerId));
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
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        heroTag: 'map-fab',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TournamentMapWidget(
                                  tournaments: state.tournaments),
                            ),
                          );
                        },
                        child: const Icon(Icons.map),
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
    final DateFormat dateFormat =
        DateFormat.yMMMd(Localizations.localeOf(context).toString());

    return Card(
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
                    Text(
                      tournament.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
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
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              tournament.location,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.videogame_asset,
                                color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              'Game: ${tournament.game.name}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              'Start: ${dateFormat.format(tournament.startDate)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              'End: ${dateFormat.format(tournament.endDate)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
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
                                ],
                                stops: const [0.0, 0.3, 0.6, 1.0],
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
                                    tournament: tournament),
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
    );
  }
}
