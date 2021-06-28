import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class Album {
  final String title;
  final Set<Song> songs;

  Album(this.title, this.songs);

  factory Album.fromJson(dynamic data) {
    final songs = data['songs'].map<Song>((it) => Song.fromJson(it)).toSet();
    return Album(data['title'], songs);
  }

  void printInfo() {
    print('---$title---');
    songs.forEach((element) {
      print(element);
    });
  }
}

class Song extends Equatable {
  final String title;
  final String artist;
  final int duration;
  final List<String> genres;

  Song(this.title, this.artist, this.duration, {this.genres = const []});

  @override
  List<Object?> get props => [title, artist];

  factory Song.fromJson(dynamic data) {
    return Song(data['name'], data['artist'], data['duration'],
        genres: List<String>.from(data['genres']));
  }

  @override
  String toString() {
    return '$title - $duration';
  }
}

void main(List<String> arguments) async {
  final response = await Dio().get<List<dynamic>>(
      'https://fivedots.coe.psu.ac.th/~suthon/data/songs.json');

  final albums = response.data?.map<Album>((e) => Album.fromJson(e)).toList();
  albums?.forEach((element) {
    element.printInfo();
  });

  final songs = SplayTreeSet<Song>.from({}, (a, b) => b.duration - a.duration);
  albums?.forEach((element) {
    songs.addAll(element.songs);
  });
  final albumC = Album('Alubm C', songs);
  albumC.printInfo();
}
