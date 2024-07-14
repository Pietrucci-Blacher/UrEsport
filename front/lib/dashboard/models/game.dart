// lib/models/game.dart
class Game {
  final int id;
  late final String name;
  late final String description;
  late final String image;
  late final String tags;
  late final String createdAt;
  late final String updatedAt;

  Game({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });
}

List<Game> games = [
  Game(
    id: 1,
    name: 'The Legend of Zelda: Breath of the Wild',
    description: 'An open-world action-adventure game set in a vast and beautiful world.',
    image: 'zelda_botw.png',
    tags: 'adventure, open-world, action',
    createdAt: '2017-03-03 00:00:00',
    updatedAt: '2017-03-03 00:00:00',
  ),
  Game(
    id: 2,
    name: 'Fortnite',
    description: 'A battle royale game where players fight to be the last one standing.',
    image: 'fortnite.png',
    tags: 'battle royale, multiplayer, action',
    createdAt: '2017-07-21 00:00:00',
    updatedAt: '2017-07-21 00:00:00',
  ),
  Game(
    id: 3,
    name: 'Minecraft',
    description: 'A sandbox game that allows players to build and explore their own worlds.',
    image: 'minecraft.png',
    tags: 'sandbox, adventure, creative',
    createdAt: '2011-11-18 00:00:00',
    updatedAt: '2011-11-18 00:00:00',
  ),
  Game(
    id: 4,
    name: 'Overwatch',
    description: 'A team-based shooter game featuring a diverse cast of characters.',
    image: 'overwatch.png',
    tags: 'shooter, team-based, multiplayer',
    createdAt: '2016-05-24 00:00:00',
    updatedAt: '2016-05-24 00:00:00',
  ),
  Game(
    id: 5,
    name: 'League of Legends',
    description: 'A multiplayer online battle arena game where players control champions.',
    image: 'league_of_legends.png',
    tags: 'MOBA, multiplayer, strategy',
    createdAt: '2009-10-27 00:00:00',
    updatedAt: '2009-10-27 00:00:00',
  ),
  Game(
    id: 6,
    name: 'Apex Legends',
    description: 'A free-to-play battle royale game set in the Titanfall universe.',
    image: 'apex_legends.png',
    tags: 'battle royale, multiplayer, action',
    createdAt: '2019-02-04 00:00:00',
    updatedAt: '2019-02-04 00:00:00',
  ),
  Game(
    id: 7,
    name: 'Animal Crossing: New Horizons',
    description: 'A social simulation game where players build and manage their own island.',
    image: 'animal_crossing.png',
    tags: 'simulation, social, casual',
    createdAt: '2020-03-20 00:00:00',
    updatedAt: '2020-03-20 00:00:00',
  ),
  Game(
    id: 8,
    name: 'Call of Duty: Warzone',
    description: 'A battle royale game set in the Call of Duty universe.',
    image: 'warzone.png',
    tags: 'battle royale, shooter, multiplayer',
    createdAt: '2020-03-10 00:00:00',
    updatedAt: '2020-03-10 00:00:00',
  ),
  Game(
    id: 9,
    name: 'Cyberpunk 2077',
    description: 'An open-world RPG set in a dystopian future.',
    image: 'cyberpunk_2077.png',
    tags: 'RPG, open-world, action',
    createdAt: '2020-12-10 00:00:00',
    updatedAt: '2020-12-10 00:00:00',
  ),
  Game(
    id: 10,
    name: 'Among Us',
    description: 'A multiplayer party game where players must find the imposter among them.',
    image: 'among_us.png',
    tags: 'party, multiplayer, social deduction',
    createdAt: '2018-06-15 00:00:00',
    updatedAt: '2018-06-15 00:00:00',
  ),
  // Ajoutez plus de jeux ici
];