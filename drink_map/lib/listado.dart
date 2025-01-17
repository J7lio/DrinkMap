import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiscotecaSearch(),
    );
  }
}

class DiscotecaSearch extends StatefulWidget {
  @override
  _DiscotecaSearchState createState() => _DiscotecaSearchState();
}

class _DiscotecaSearchState extends State<DiscotecaSearch> {
  final TextEditingController _cityController = TextEditingController();
  String _selectedCity = '';
  bool _showResult = false;
  bool _cityNotFound = false;
  String _selectedOrder = 'Más votos';
  List<Discoteca> favoriteDiscotecas = [];

  // Lista de discotecas por ciudad
  List<Discoteca> valenciaDiscotecas = [
    Discoteca(name: 'Akuarela Playa', address: 'Carrer el Camí 1D', price: 20, votesYes: 10),
    Discoteca(name: 'Spook', address: 'Carrer de la Senda, Valencia', price: 25, votesYes: 5),
    Discoteca(name: 'Mya', address: 'Avenida de las Cortes Valencianas, Valencia', price: 30, votesYes: 20),
  ];

  List<Discoteca> madridDiscotecas = [
    Discoteca(name: 'Fabrik', address: 'Humanes, Madrid', price: 40, votesYes: 25),
    Discoteca(name: 'Teatro Barcelo', address: 'Madrid, Centro', price: 35, votesYes: 20),
    Discoteca(name: 'Panda', address: 'Madrid, Centro', price: 30, votesYes: 15),
  ];

  List<Discoteca> barcelonaDiscotecas = [
    Discoteca(name: 'Razzmatazz', address: 'Barcelona, Centro', price: 30, votesYes: 30),
    Discoteca(name: 'Opium', address: 'Barcelona, Playa', price: 35, votesYes: 25),
    Discoteca(name: 'Latin Place Barcelona', address: 'Barcelona, Centro', price: 20, votesYes: 10),
  ];

  List<Discoteca> sevillaDiscotecas = [
    Discoteca(name: 'Uthopia', address: 'Sevilla, Centro', price: 25, votesYes: 15),
    Discoteca(name: 'Koko', address: 'Sevilla, Centro', price: 20, votesYes: 12),
    Discoteca(name: 'Occo', address: 'Sevilla, Centro', price: 30, votesYes: 18),
  ];

  List<Discoteca> mallorcaDiscotecas = [
    Discoteca(name: 'BCM', address: 'Magaluf, Mallorca', price: 30, votesYes: 15),
    Discoteca(name: 'Panama Jack', address: 'Magaluf, Mallorca', price: 25, votesYes: 10),
    Discoteca(name: 'Titos', address: 'Palma, Mallorca', price: 20, votesYes: 8),
  ];

  List<Discoteca> ibizaDiscotecas = [
    Discoteca(name: 'Amnesia', address: 'Ibiza, Centro', price: 50, votesYes: 35),
    Discoteca(name: 'Usuhaya', address: 'Ibiza, Playa', price: 60, votesYes: 40),
    Discoteca(name: 'Pacha', address: 'Ibiza, Centro', price: 45, votesYes: 30),
  ];

  final List<String> availableCities = ['Valencia', 'Madrid', 'Barcelona', 'Sevilla', 'Mallorca', 'Ibiza'];

  // Buscar ciudad
  void _searchCity() {
    String searchText = _cityController.text.toLowerCase();
    setState(() {
      _cityNotFound = false;
      _showResult = true;
      if (searchText == 'valencia') {
        _selectedCity = 'Valencia';
        _sortDiscotecas(valenciaDiscotecas);
      } else if (searchText == 'madrid') {
        _selectedCity = 'Madrid';
        _sortDiscotecas(madridDiscotecas);
      } else if (searchText == 'barcelona') {
        _selectedCity = 'Barcelona';
        _sortDiscotecas(barcelonaDiscotecas);
      } else if (searchText == 'sevilla') {
        _selectedCity = 'Sevilla';
        _sortDiscotecas(sevillaDiscotecas);
      } else if (searchText == 'mallorca') {
        _selectedCity = 'Mallorca';
        _sortDiscotecas(mallorcaDiscotecas);
      } else if (searchText == 'ibiza') {
        _selectedCity = 'Ibiza';
        _sortDiscotecas(ibizaDiscotecas);
      } else {
        _cityNotFound = true;
        _showResult = false;
      }
    });
  }

  void _sortDiscotecas(List<Discoteca> discotecas) {
    if (_selectedOrder == 'Más votos') {
      discotecas.sort((a, b) => b.votesYes.compareTo(a.votesYes));
    } else if (_selectedOrder == 'Mayor precio') {
      discotecas.sort((a, b) => b.price.compareTo(a.price));
    } else if (_selectedOrder == 'Menor precio') {
      discotecas.sort((a, b) => a.price.compareTo(b.price));
    }
  }

  void _vote(Discoteca discoteca) {
    setState(() {
      discoteca.votesYes++;
      _sortDiscotecas(_getDiscotecas());
    });
  }

  void _toggleFavorite(Discoteca discoteca) {
    setState(() {
      if (favoriteDiscotecas.contains(discoteca)) {
        favoriteDiscotecas.remove(discoteca);
      } else {
        favoriteDiscotecas.add(discoteca);
      }
    });
  }

  void _openChat(Discoteca discoteca) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(discoteca: discoteca),
      ),
    );
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoritesScreen(favoriteDiscotecas: favoriteDiscotecas),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discotecas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: _openFavorites,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'Introduce una ciudad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchCity,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            if (_cityNotFound)
              Text(
                'Ciudad no encontrada. Opciones disponibles: ${availableCities.join(', ')}.',
                style: TextStyle(color: Colors.red),
              ),
            if (_showResult) ...[
              Row(
                children: [
                  Text('Ordenar por: '),
                  SizedBox(width: 8.0),
                  DropdownButton<String>(
                    value: _selectedOrder,
                    items: [
                      'Más votos',
                      'Mayor precio',
                      'Menor precio',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedOrder = newValue!;
                        if (_selectedCity == 'Valencia') {
                          _sortDiscotecas(valenciaDiscotecas);
                        } else if (_selectedCity == 'Madrid') {
                          _sortDiscotecas(madridDiscotecas);
                        } else if (_selectedCity == 'Barcelona') {
                          _sortDiscotecas(barcelonaDiscotecas);
                        } else if (_selectedCity == 'Sevilla') {
                          _sortDiscotecas(sevillaDiscotecas);
                        } else if (_selectedCity == 'Mallorca') {
                          _sortDiscotecas(mallorcaDiscotecas);
                        } else if (_selectedCity == 'Ibiza') {
                          _sortDiscotecas(ibizaDiscotecas);
                        }
                      });
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _getDiscotecas().length,
                  itemBuilder: (context, index) {
                    final discoteca = _getDiscotecas()[index];
                    return Card(
                      elevation: 4.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.0),
                              color: Colors.blueGrey,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    discoteca.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      favoriteDiscotecas.contains(discoteca)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _toggleFavorite(discoteca),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_pin, color: Colors.blue),
                                      SizedBox(width: 8.0),
                                      Text(discoteca.address),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Text(
                                    '€${discoteca.price}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Votos: ${discoteca.votesYes}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => _vote(discoteca),
                                        child: Text('Yo voto'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  ElevatedButton(
                                    onPressed: () => _openChat(discoteca),
                                    child: Text('Foro de Chat'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Discoteca> _getDiscotecas() {
    switch (_selectedCity) {
      case 'Valencia':
        return valenciaDiscotecas;
      case 'Madrid':
        return madridDiscotecas;
      case 'Barcelona':
        return barcelonaDiscotecas;
      case 'Sevilla':
        return sevillaDiscotecas;
      case 'Mallorca':
        return mallorcaDiscotecas;
      case 'Ibiza':
        return ibizaDiscotecas;
      default:
        return [];
    }
  }
}

class Discoteca {
  String name;
  String address;
  int price;
  int votesYes;
  List<String> chatMessages = [];

  Discoteca({required this.name, required this.address, required this.price, this.votesYes = 0});
}

class ChatScreen extends StatefulWidget {
  final Discoteca discoteca;

  ChatScreen({required this.discoteca});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatController = TextEditingController();

  void _sendMessage() {
    if (_chatController.text.isNotEmpty) {
      setState(() {
        widget.discoteca.chatMessages.add(_chatController.text);
        _chatController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foro: ${widget.discoteca.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.discoteca.chatMessages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.discoteca.chatMessages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(hintText: 'Escribe un mensaje...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<Discoteca> favoriteDiscotecas;

  FavoritesScreen({required this.favoriteDiscotecas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
      ),
      body: favoriteDiscotecas.isEmpty
          ? Center(child: Text('No tienes discotecas favoritas.'))
          : ListView.builder(
              itemCount: favoriteDiscotecas.length,
              itemBuilder: (context, index) {
                final discoteca = favoriteDiscotecas[index];
                return ListTile(
                  title: Text(discoteca.name),
                  subtitle: Text(discoteca.address),
                );
              },
            ),
    );
  }
}