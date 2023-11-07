import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Movie {
  final String title;
  final String posterPath;

  Movie({required this.title, required this.posterPath});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      posterPath: json['poster_path'],
    );
  }
}

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({Key? key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final String apiKey = 'fa3e844ce31744388e07fa47c7c5d8c3';
  final String apiUrl =
      'https://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc';

  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await Dio().get(apiUrl, queryParameters: {
        'api_key': apiKey,
      });

      if (response.statusCode == 200) {
        final data = response.data['results'] as List<dynamic>;
        final movieList = data.map((e) => Movie.fromJson(e)).toList();

        setState(() {
          movies = movieList;
        });
      } else {
        print('Failed to fetch data.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Películas Populares"),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return ListTile(
            title: Text(movie.title),
            leading: Image.network(
              'https://image.tmdb.org/t/p/w92${movie.posterPath}',
            ),
          );
        },
      ),
    );
  }
}
