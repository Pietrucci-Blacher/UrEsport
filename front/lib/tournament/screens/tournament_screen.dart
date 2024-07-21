import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uresport/core/models/team.dart';
import 'package:uresport/core/models/tournament.dart';
import 'package:uresport/core/models/user.dart';
import 'package:uresport/core/services/auth_service.dart';
import 'package:uresport/core/services/team_services.dart';
import 'package:uresport/core/services/tournament_service.dart';
import 'package:uresport/l10n/app_localizations.dart';
import 'package:uresport/shared/map/map.dart';
import 'package:uresport/team/screen/add_team.dart';
import 'package:uresport/team/screen/team_member.dart';
import 'package:uresport/tournament/bloc/tournament_bloc.dart';
import 'package:uresport/tournament/bloc/tournament_event.dart';
import 'package:uresport/tournament/bloc/tournament_state.dart';
import 'package:uresport/tournament/screens/add_tournament.dart';
import 'package:uresport/tournament/screens/tournament_details_screen.dart';
import 'package:uresport/widgets/custom_toast.dart';
import 'package:uresport/widgets/gradient_icon.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});

  @override
  TournamentScreenState createState() => TournamentScreenState();
}

class TournamentScreenState extends State<TournamentScreen> {
  User? _currentUser;
  bool _isLoggedIn = false;

  Future<void> _loadCurrentUser() async {
    final authService = Provider.of<IAuthService>(context, listen: false);
    try {
      final user = await authService.getUser();
      if (!mounted) return;
      setState(() {
        _currentUser = user;
        _isLoggedIn = true;
      });
    } catch (e) {
      debugPrint('Error loading current user: $e');
      setState(() {
        _isLoggedIn = false;
      });
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
              Tab(text: l.listMyTeamsJoined),
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
        AppLocalizations l = AppLocalizations.of(context);

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          debugPrint('Error in FutureBuilder: ${snapshot.error}');
          return Center(child: Text(l.failedToLoadUserTeams));
        } else if (!snapshot.hasData || (snapshot.data as List<Team>).isEmpty) {
          return Center(child: Text(l.noTeamsFoundForUser));
        } else {
          final teams = snapshot.data as List<Team>;
          debugPrint('Teams data: $teams');
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  setState(() {}); // Trigger FutureBuilder to reload data
                  await _loadUserTeams(); // Load teams again
                },
                child: ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: (context, index) {
                    final team = teams[index];
                    final isOwner = team.ownerId == _currentUser!.id;
                    return GestureDetector(
                      onTap: () {
                        // Log the data étant envoyé à TeamMembersPage
                        debugPrint('Navigating to TeamMembersPage avec:');
                        debugPrint('Team Name: ${team.name}');
                        debugPrint('Members: ${team.members}');

                        // Convert members to User objects
                        List<User> userMembers = team.members.map((memberJson) {
                          return User.fromJson(memberJson);
                        }).toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeamMembersPage(
                              teamId: team.id,
                              teamName: team.name,
                              members: userMembers,
                              ownerId: team.ownerId,
                              currentId: _currentUser!.id,
                            ),
                          ),
                        );
                      },
                      child: Dismissible(
                        key: Key(team.id.toString()),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          _confirmLeaveTeam(team.id, team.name, isOwner);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 20.0),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: ListTile(
                          title: Text(team.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            l.membersAndTournaments(
                                team.members.length, team.tournaments.length),
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.info, color: Colors.grey),
                            onPressed: () => _showTeamTournaments(context, team),
                          ),
                        ),
                      ),
                    );
                  },

                ),
              ),
              if (_isLoggedIn)
                Positioned(
                  bottom: 16.0,
                  right: 16.0,
                  child: FloatingActionButton(
                    heroTag: 'add-team',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTeamPage(),
                        ),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  void _showTeamTournaments(BuildContext context, Team team) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        AppLocalizations l = AppLocalizations.of(context);
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: team.tournaments.isEmpty
              ? Center(
            child: Text(
              l.noJoinedTournaments, // Assurez-vous que cette clé existe dans vos localisations
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.tournaments,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ...team.tournaments.map((tournamentJson) {
                Tournament tournament = Tournament.fromJson(tournamentJson);
                return ListTile(
                  contentPadding: const EdgeInsets.all(10.0),
                  leading: Image.network(tournament.image, width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(tournament.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.tournamentStartDate(tournament.startDate), style: const TextStyle(fontSize: 14)),
                      Text(l.tournamentEndDate(tournament.endDate), style: const TextStyle(fontSize: 14)),
                      Text(tournament.description, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TournamentDetailsScreen(tournament: tournament, game: tournament.game),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }



  Future<void> _confirmLeaveTeam(int teamId, String teamName, bool isOwner) async {
    AppLocalizations l = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l.confirmAction),
          content: Text(isOwner ? l.deleteTeamConfirmation(teamName) : l.leaveTeamConfirmation(teamName)),
          actions: <Widget>[
            TextButton(
              child: Text(l.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(isOwner ? l.delete : l.leave),
              onPressed: () {
                Navigator.of(context).pop();
                if (isOwner) {
                  _deleteTeam(teamId, teamName);
                } else {
                  _leaveTeam(teamId, teamName);
                }
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _deleteTeam(int teamId, String teamName) async {
    if (_currentUser == null) return;

    final teamService = Provider.of<ITeamService>(context, listen: false);
    try {
      await teamService.deleteTeam(teamId);
      setState(() {
        // Reload the teams after deleting a team
        _loadUserTeams();
      });
      if (!mounted) return;
      _showToast(AppLocalizations.of(context).teamDeleted(teamName), Colors.green);
    } catch (e) {
      _showToast(AppLocalizations.of(context).failedToDeleteTeam(e.toString()), Colors.red);
    }
  }

  Future<void> _leaveTeam(int teamId, String teamName) async {
    if (_currentUser == null) return;

    final userId = _currentUser!.id;
    final teamService = Provider.of<ITeamService>(context, listen: false);
    try {
      await teamService.leaveTeam(userId, teamId);
      setState(() {
        // Reload the teams after leaving a team
        _loadUserTeams();
      });
      if (!mounted) return;
      _showToast(AppLocalizations.of(context).teamLeft(teamName), Colors.green);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        final errorResponse = e.response?.data;
        final errorMessage = errorResponse['error'] ?? AppLocalizations.of(context).failedToLeaveTeam;
        _showToast(errorMessage, Colors.red);
      } else {
        if (!mounted) return;
        _showToast(AppLocalizations.of(context).failedToLeaveTeam, Colors.red);
      }
    }
  }

  void _showToast(String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: CustomToast(
          message: message,
          backgroundColor: backgroundColor,
          onClose: () {
            overlayEntry.remove();
          },
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  Future<List<Team>> _loadUserTeams() async {
    if (_currentUser == null) {
      throw Exception(AppLocalizations.of(context).failedToLoadUserTeams);
    }

    final teamService = Provider.of<ITeamService>(context, listen: false);
    return await teamService.getUserTeams(_currentUser!.id);
  }

  Widget _buildTournamentList(BuildContext context, bool isOwner) {
    var ownerId = isOwner ? _currentUser?.id : null;
    AppLocalizations l = AppLocalizations.of(context);

    if (isOwner && ownerId == null) {
      return Center(child: Text(l.mustBeLoggedIn));
    }

    return BlocProvider(
      create: (context) => TournamentBloc(context.read<ITournamentService>())..add(LoadTournaments(ownerId: ownerId)),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<TournamentBloc>().add(LoadTournaments(ownerId: ownerId));
          },
          child: BlocBuilder<TournamentBloc, TournamentState>(
            builder: (context, state) {
              AppLocalizations l = AppLocalizations.of(context);

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
                                      builder: (context) => const AddTournamentPage(),
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
                return Center(child: Text(l.failedToLoadTournaments));
              }
              return Center(child: Text(l.unknownState));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTournamentCard(BuildContext context, Tournament tournament) {
    AppLocalizations l = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TournamentDetailsScreen(tournament: tournament, game: tournament.game),
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
                                    l.gameName(tournament.game.name),
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
                                    l.tournamentStartDate(tournament.startDate),
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
                                    l.tournamentEndDate(tournament.endDate),
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
                                    l.teamPlayersCount(tournament.nbPlayers),
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
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
                            child: Text(l.viewDetails),
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