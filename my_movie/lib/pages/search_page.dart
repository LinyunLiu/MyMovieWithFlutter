import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_movie/pages/detail_page.dart';
import 'package:my_movie/utils/alert_helper.dart';

String search = "avengers";

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>>? searchResults;
  bool isLoading = false;
  bool hasResult = false;

  void _startSearch(String text) async {
    setState(() {
      isLoading = true;
    });
    bool result = await fetchData(text);
    setState(() {
      hasResult = result;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.text = search;
    _startSearch(search);
  }

  Future<bool> fetchData(String search) async {
  try {
    final response = await http.get(
      Uri.parse('https://www.omdbapi.com/?apikey=${dotenv.env['OMDB_KEY']}&s=$search'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['Search'] != null) {
        final List<dynamic> rawResults = data['Search'];
        final List<Map<String, String>> parsedResults = rawResults.map<Map<String, String>>((item) {
          return {
            'Title': item['Title'] ?? '',
            'Year': item['Year'] ?? '',
            'Poster': item['Poster'] ?? '',
            'ID': item['imdbID'] ?? '',
          };
        }).toList();
        setState(() {
          searchResults = parsedResults;
        });
        if (searchResults!.isEmpty){
          return false;
        }
        else{
          return true;
        }
      } else {
        setState(() {
          searchResults = [];
        });
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) {
              if (value.trim() != ""){
                search = value;
                _startSearch(value);
              }
              else{
                AlertHelper.showTopFlushbar(context, "Input is empty");
              }
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              filled: true,
              fillColor: Color(0xFFFAEBD7),
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: BorderSide.none, // remove outline
              ),
            ),
          ),
          SizedBox(height: 20),
          if (isLoading)
            Expanded(child: Center(child: CircularProgressIndicator()))
          else
            if (hasResult)
              results()
            else
              message('No Results')
          
        ],
      ),
    );
  }

  Expanded message(String msg){
    return Expanded(
      child: Center(
        child: Text(
          msg,
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFFAEBD7),
          ),
        ),
      )
    );
  }

  Expanded results(){
    return Expanded(
      child: ListView.builder(
        itemCount: searchResults!.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Color.fromARGB(255, 22, 22, 22),
              builder: (context) {
                  return DetailPage(itemId: searchResults![index]['ID']!);
              }
            );
          },
          child: result(searchResults![index])
        )
      )
    );
  }
  Container result(Map<String, String> movie){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            height: 90,
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Image.network(
                movie['Poster']!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.image),
              ),
            ),
          ),
          SizedBox(width: 12), // spacing
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie['Title']!,
                  style: TextStyle(fontSize: 16, color: Color(0xFFFAEBD7)),
                ),
                SizedBox(height: 4),
                Text(
                  '${movie['Year']}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


