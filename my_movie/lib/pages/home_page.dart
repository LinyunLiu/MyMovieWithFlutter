import 'package:flutter/material.dart';
import 'package:my_movie/pages/detail_page.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  final List<String> movieTitles = [
    'M3GAN',
    'The Hunt',
    'Prospect',
    'Final Destination: Bloodlines',
    'Django Unchained',
    'Inglourious Basterds',
    'Pulp Fiction',
    'Interstellar',
    'Avengers: Endgame',
    'The 100',
    'Lucifer',
    'Arrow',
    'The Imitation Game',
    'Doctor Strange',
    'Inception',
    'The Matrix',
    'Interstellar',
    'The Shawshank Redemption',
    'The Dark Knight',
    'Fight Club',
    'Forrest Gump',
    'The Godfather',
    'The Lord of the Rings: The Fellowship of the Ring',
    'Gladiator',
    'Titanic',
    'The Social Network',
    'Whiplash',
    'Parasite'
  ];
  final List<String> movieIds = 
  [
  'tt8760708', 'tt2106476', 'tt7946422', 'tt9619824', 'tt1853728', 
  'tt0361748', 'tt0110912', 'tt0816692', 'tt4154796', 'tt2661044',
  'tt4052886', 'tt2193021', 'tt2084970', 'tt1211837', 'tt1375666',
  'tt0133093', 'tt0816692', 'tt0111161', 'tt0468569', 'tt0137523',
  'tt0109830', 'tt0068646', 'tt0120737', 'tt0172495', 'tt0120338',
  'tt1285016', 'tt2582802', 'tt6751668'
  ];

  final List<String> moviePosters = [
    'https://m.media-amazon.com/images/M/MV5BYjU1ZWMxYTUtNzQ1ZC00ZTcxLTg0NTMtMzY1ZmQyZjhmYjMyXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BMTg2NDg3ODg4NF5BMl5BanBnXkFtZTcwNzk3NTc3Nw@@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BN2QzYzU1ZGUtOGJjYy00ODNmLWFhNWYtYjBkMWRkZTQ3M2E0XkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BMzc3OWFhZWItMTE2Yy00N2NmLTg1YTktNGVlNDY0ODQ5YjNlXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BMjIyNTQ5NjQ1OV5BMl5BanBnXkFtZTcwODg1MDU4OA@@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BODZhMWJlNjYtNDExNC00MTIzLTllM2ItOGQ2NGVjNDQ3MzkzXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BYTViYTE3ZGQtNDBlMC00ZTAyLTkyODMtZGRiZDg0MjA2YThkXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BNDdmZGYwOWEtN2FkZC00Y2ExLWJkY2UtNzFlODVlNzc3MGIzXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BYzMwNzI3MWItZTIzYi00YjkxLThhOWQtYmUwYjg4NWM0ZWI1XkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BNjRlNjNlY2YtYzQxNS00ZTUzLTkwMTQtMjM0YjZlOWQwZmFkXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BNjI3NjY1Mjg3MV5BMl5BanBnXkFtZTgwMzk5MDQ3MjE@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BNjgwNzAzNjk1Nl5BMl5BanBnXkFtZTgwMzQ2NjI1OTE@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BN2NmN2VhMTQtMDNiOS00NDlhLTliMjgtODE2ZTY0ODQyNDRhXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BMDAyY2FhYjctNDc5OS00MDNlLThiMGUtY2UxYWVkNGY2ZjljXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BOTgyOGQ1NDItNGU3Ny00MjU3LTg2YWEtNmEyYjBiMjI1Y2M5XkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BNDYwNzVjMTItZmU5YS00YjQ5LTljYjgtMjY2NDVmYWMyNWFmXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BNGEwYjgwOGQtYjg5ZS00Njc1LTk2ZGEtM2QwZWQ2NjdhZTE5XkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BNzIxMDQ2YTctNDY4MC00ZTRhLTk4ODQtMTVlOWY4NTdiYmMwXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BYWQ4YmNjYjEtOWE1Zi00Y2U4LWI4NTAtMTU0MjkxNWQ1ZmJiXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BYzYyN2FiZmUtYWYzMy00MzViLWJkZTMtOGY1ZjgzNWMwN2YxXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BMjlkNTE5ZTUtNGEwNy00MGVhLThmZjMtZjU1NDE5Zjk1NDZkXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BMDFjOWFkYzktYzhhMC00NmYyLTkwY2EtYjViMDhmNzg0OGFkXkEyXkFqcGc@._V1_SX300.jpg',
    'https://m.media-amazon.com/images/M/MV5BYjk1Y2U4MjQtY2ZiNS00OWQyLWI3MmYtZWUwNmRjYWRiNWNhXkEyXkFqcGc@._V1_SX300.jpg'
  ];

  List<int> generateUniqueRandomNumbers({int count = 8, int max = 25}) {
    final random = Random();
    List<int> allNumbers = List.generate(max + 1, (index) => index);
    allNumbers.shuffle(random);
    return allNumbers.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<int> selected = generateUniqueRandomNumbers();
    return ListView(
      padding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 50),
      children: [
        // FIRST SECTION
        Text(
          'Top Picks',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFFFAEBD7),
            fontFamily: 'Anton'
          ),
        ),

        SizedBox(height: 20),

        // SECOND SECTION
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: selected.length,
        
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,          // 2 columns
            crossAxisSpacing: 4,        // horizontal spacing between items
            mainAxisSpacing: 4,         // vertical spacing between items
            childAspectRatio: 0.55,      // width/height ratio of each item 
          ), 
        
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Color.fromARGB(255, 22, 22, 22),
                builder: (context) {
                    return DetailPage(itemId: movieIds[selected[index]]);
                }
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.network(
                      moviePosters[selected[index]],
                      fit: BoxFit.cover,
                    )
                  )
                ),
                const SizedBox(height: 8),
                Text(
                  movieTitles[selected[index]],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFFAEBD7),
                  ),
                ),
              ],
            ),
          ),
        ),
        //

      ]
    );
  }
}


