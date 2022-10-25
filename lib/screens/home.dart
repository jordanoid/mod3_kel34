import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detailAir.dart';
import 'detail.dart';
import 'about.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Show>> shows;
  late Future<List<Show>> showsair;
  @override
  void initState() {
    super.initState();
    shows = fetchShow();
    showsair = fetchShowOnAir();
  }

  final items = const [
    Icon(
      Icons.home,
      size: 30,
    ),
    Icon(
      Icons.people,
      size: 30,
    ),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('My Anime List', style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(7),
            child: const Text(
              'Top Airing',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          FutureBuilder(
            builder: (context, AsyncSnapshot<List<Show>> snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 230,
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) => Card(
                      color: Colors.white,
                      child: InkWell(
                        child: Container(
                          height: 200,
                          width: 150,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Image.network(
                                    snapshot.data![index].images.jpg.image_url,
                                    height: 200,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    height: 170,
                                    width: 150,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Opacity(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: Container(
                                                  padding: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[800]),
                                                  child: Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        size: 20,
                                                        color: Colors.yellow,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          snapshot.data![index]
                                                              .score
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              opacity: 0.7,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                snapshot.data![index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailAirPage(
                                        item: snapshot.data![index].malId,
                                        title: snapshot.data![index].title,
                                      )));
                        },
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong :('));
              }
              return const CircularProgressIndicator();
            },
            future: showsair,
          ),
          Container(
            padding: EdgeInsets.all(7),
            child: const Text(
              'Top of All Time',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              builder: (context, AsyncSnapshot<List<Show>> snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  snapshot.data![index].images.jpg.image_url),
                            ),
                            title: Text(snapshot.data![index].title),
                            subtitle:
                                Text('Score: ${snapshot.data![index].score}'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                      item: snapshot.data![index].malId,
                                      title: snapshot.data![index].title),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('${snapshot.error}'));
                }
                return const CircularProgressIndicator();
              },
              future: shows,
            ),
          ),
        ],
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const HomePage();
        break;
      case 1:
        widget = const About();
        break;
      default:
        widget = const HomePage();
        break;
    }
    return widget;
  }
}

class Show {
  final int malId;
  final String title;
  Images images;
  final double score;
  //final String imageUrl;
  Show({
    required this.malId,
    required this.title,
    required this.images,
    required this.score,
    //required this.imageUrl,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      malId: json['mal_id'],
      title: json['title'],
      images: Images.fromJson(json['images']),
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() => {
        'mal_id': malId,
        'title': title,
        'images': images,
        'score': score,
      };
}

class Images {
  final Jpg jpg;

  Images({required this.jpg});
  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      jpg: Jpg.fromJson(json['jpg']),
    );
  }

  Map<String, dynamic> toJson() => {
        'jpg': jpg.toJson(),
      };
}

class Jpg {
  String image_url;
  String small_image_url;
  String large_image_url;

  Jpg({
    required this.image_url,
    required this.small_image_url,
    required this.large_image_url,
  });

  factory Jpg.fromJson(Map<String, dynamic> json) {
    return Jpg(
      image_url: json['image_url'],
      small_image_url: json['small_image_url'],
      large_image_url: json['large_image_url'],
    );
  }
  //to json
  Map<String, dynamic> toJson() => {
        'image_url': image_url,
        'small_image_url': small_image_url,
        'large_image_url': large_image_url,
      };
}

Future<List<Show>> fetchShow() async {
  final response =
      await http.get(Uri.parse('https://api.jikan.moe/v4/top/anime'));

  if (response.statusCode == 200) {
    var jsonResponse = json.decode(response.body)['data'] as List;
    return jsonResponse.map((show) => Show.fromJson(show)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}

Future<List<Show>> fetchShowOnAir() async {
  final response = await http
      .get(Uri.parse('https://api.jikan.moe/v4/top/anime?filter=airing'));
  if (response.statusCode == 200) {
    var topShowsJson = jsonDecode(response.body)['data'] as List;
    return topShowsJson.map((showair) => Show.fromJson(showair)).toList();
  } else {
    throw Exception('Failed to load shows');
  }
}
