import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_movie/utils/alert_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetailPage extends StatefulWidget {
  
  final String itemId;
  const DetailPage({super.key, required this.itemId});

  @override
  DetailPageState createState() => DetailPageState();
}

class DetailPageState extends State<DetailPage>{

  Map<String, String>? fetchedData;
  var movies = Hive.box('movies');

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<bool> fetchData() async {
    try{
        final response = await http.get(Uri.parse('https://www.omdbapi.com/?apikey=${dotenv.env['OMDB_KEY']}&i=${widget.itemId}&plot=full'));
        if (response.statusCode == 200) {
        // Decode the JSON
        final Map<String, dynamic> data = json.decode(response.body);
        String id       = data['imdbID'] ?? '';
        String poster   = data['Poster'] ?? '';
        String title    = data['Title'] ?? '';
        String year     = data['Year'] ?? '';
        String runtime  = data['Runtime'] ?? '';
        String genre    = data['Genre'] ?? '';
        String rated    = data['Rated'] ?? '';
        String imdb     = data['imdbRating'] ?? '---';  // Be sure it's not imdbRatings
        String plot     = data['Plot'] ?? '';
        String director = data['Director'] ?? '';

        String rt = '---';  // default fallback
        if (data['Ratings'] != null && data['Ratings'] is List) {
          List ratingsList = data['Ratings'];
          var rtRating = ratingsList.firstWhere(
            (rating) => rating['Source'] == 'Rotten Tomatoes',
            orElse: () => null,
          );
          if (rtRating != null && rtRating['Value'] != null) {
            rt = rtRating['Value'];
          }
        }

        setState(() {
          fetchedData = {
            'Id': id,
            'Poster': poster,
            'Title': title,
            'Year': year,
            'Runtime': runtime,
            'Genre': genre,
            'Rated': rated,
            'IMDB': imdb,
            'RT': rt,
            'Plot': plot,
            'Director': director,
          };
        });
        return true;
      } else {
        return false;
      }
    }catch (e) {
      return false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (fetchedData == null) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false, // remove default back if any
              backgroundColor: Color.fromARGB(255, 22, 22, 22),
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.close_sharp, color: Color(0xFFFAEBD7),), // or Icons.close
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'Details',
                style: TextStyle(
                  color: Color(0xFFFAEBD7),
                  fontFamily: 'Anton',
                  fontSize: 16,
                ),
              ),
              centerTitle: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    poster(),
                    SizedBox(height: 12),
                    title(),
                    SizedBox(height: 12),
                    info(),
                    SizedBox(height: 12),
                    ratings(),
                    SizedBox(height: 12),
                    plot(),
                    SizedBox(height: 35),
                    director(),
                    SizedBox(height: 35),
      
                    if (movies.containsKey(fetchedData!['Id']))
                      deleteButton()
                    else
                      addButton(),
      
                    SizedBox(height: 100),
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  IconButton addButton(){
    return IconButton(
      onPressed: () {
        movies.put(fetchedData!['Id'].toString(), [fetchedData!['Title'].toString(), fetchedData!['Poster'].toString()]);
        Navigator.of(context).pop();
        AlertHelper.showTopFlushbar(context, "Saved!");
      },
      icon: Icon(
        Icons.add_circle_outline_rounded,
        size: 50,  // make it big
        color: Colors.deepOrangeAccent[100],
      ),
    );
  }

  IconButton deleteButton(){
    return IconButton(
      onPressed: () {
        movies.delete(fetchedData!['Id'].toString());
        Navigator.of(context).pop(true);
        AlertHelper.showTopFlushbar(context, "Removed!");
      },
      icon: Icon(
        Icons.delete_forever_rounded,
        size: 50,  // make it big
        color: Colors.deepOrangeAccent[100],
      ),
    );
  }

  Padding director() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        fetchedData!['Director'].toString(),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w200,
          color: Colors.deepOrange[200],
          fontFamily: 'Playwrite'
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Padding plot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        fetchedData!['Plot'].toString(),
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w200,
          color: Colors.deepOrange[100],
          fontFamily: 'Roboto'
        ),
        textAlign: TextAlign.center,
        // maxLines: 1,
        // overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Row ratings(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/imdb.png',
              width: 32, 
              height: 32,
            ),
            SizedBox(width: 10),
            Text(
              fetchedData!['IMDB'].toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange[100],
                fontFamily: 'Roboto'
              ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Row(
          children: [
            Image.asset(
              'assets/images/rt.png',
              width: 25, 
              height: 25,
            ),
            SizedBox(width: 10),
            Text(
              fetchedData!['RT'].toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange[100],
                fontFamily: 'Roboto'
              ),
            ),
          ],
        ),
      ],
    );
  }

  Center poster() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: Image.network(
            fetchedData!['Poster'].toString(),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(Icons.image),
          ),
        ),
      ),
    );
  }

  Padding title() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        fetchedData!['Title'].toString(),
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange[300],
          fontFamily: 'Anton'
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Row info() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          fetchedData!['Year'].toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange[100],
            fontFamily: 'Roboto'
          ),
        ),
        SizedBox(width: 10),
        Text(
          fetchedData!['Runtime'].toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange[100],
            fontFamily: 'Roboto'
          ),
        ),
        SizedBox(width: 10),
        Text(
          fetchedData!['Genre'].toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange[100],
            fontFamily: 'Roboto'
          ),
        ),
        SizedBox(width: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Color.fromARGB(99, 130, 125, 125), // background color
            borderRadius: BorderRadius.circular(4), // optional: rounded corners
          ),
          child: Text(
            fetchedData!['Rated'].toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange[100],
              fontFamily: 'Roboto',
            ),
          ),
        )
      ]);
  }
}