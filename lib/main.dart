import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'movies.dart'; // Asegúrate de importar el modelo Movie
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MovieTicketCalculator(),
    );
  }
}

MovieTicketCalculator() {

}

class _MovieTicketCalculatorState extends State<MovieTicketCalculator> {
  double ticketPrice = 30.0; // Precio por entrada de cualquier película en Bs.
  int numberOfTickets = 1; // Cantidad de entradas seleccionadas, se inicia en 1.
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final apiKey = 'fa3e844ce31744388e07fa47c7c5d8c3';
    
    try {
      final response = await http.get(
          'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=$apiKey' as Uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'];
        print(results); // Agrega esto para verificar los resultados
        setState(() {
          movies = results.map<Movie>((json) => Movie.fromJson(json)).toList();
        });
      } else {
        print('Failed to load movies: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching movies: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = ticketPrice * numberOfTickets;

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Entradas de Cine'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Selecciona la cantidad de entradas:',
              style: TextStyle(fontSize: 18.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (numberOfTickets > 1) {
                        numberOfTickets--;
                      }
                    });
                  },
                ),
                Text(
                  '$numberOfTickets',
                  style: TextStyle(fontSize: 24.0),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      numberOfTickets++;
                    });
                  },
                ),
              ],
            ),
            Text(
              'Precio total: $totalCost Bs.',
              style: TextStyle(fontSize: 20.0),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(movies[index].title),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Movie {
  final String title;

  Movie({required this.title});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(title: json['title']);
  }
}
