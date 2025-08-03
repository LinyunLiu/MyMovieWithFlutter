import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_movie/pages/detail_page.dart';

class ListPage extends StatefulWidget {

  const ListPage({super.key});
  @override
  ListPageState createState() => ListPageState();
}

class ListPageState extends State<ListPage> {
  var movies = Hive.box('movies');
  List<List<String>> watchlist = [];

  @override
  void initState() {
    super.initState();
    // Convert entire box to a typed Map
    if (movies.isNotEmpty){
      List<dynamic> keys = movies.keys.toList();
      for (String k in keys){
        List<String> m = movies.get(k);
        m.add(k);
        watchlist.add(m);
      }
    }
  }

  void _refreshWatchlist() {
    watchlist.clear();  // clear old data
    // Reload the data from Hive box
    if (movies.isNotEmpty){
      List<dynamic> keys = movies.keys.toList();
      for (String k in keys){
        List<String> m = movies.get(k);
        m.add(k);
        watchlist.add(m);
      }
    }
    setState(() {});  // trigger UI rebuild
  }

  @override
  Widget build(BuildContext context) {
    if (watchlist.isEmpty) {
      return Center(
        child: Text(
          'Empty List',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFFAEBD7),
          ),
        )
      );
    }
    return GridView.builder(
      itemCount: watchlist.length,
      padding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 50),

      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,          // 2 columns
        crossAxisSpacing: 4,        // horizontal spacing between items
        mainAxisSpacing: 4,         // vertical spacing between items
        childAspectRatio: 0.55,      // width/height ratio of each item 
      ), 

      itemBuilder: (context, index) => GestureDetector(
        onTap: () async {
          final result = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Color.fromARGB(255, 22, 22, 22),
            builder: (context) {
              return DetailPage(itemId: watchlist[index][2]);
            }
          );
          // If result is true, it means something changed (e.g. deleted), so refresh the watchlist
          if (result == true) {
            _refreshWatchlist();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.network(
                  watchlist[index][1],
                  fit: BoxFit.cover,
                )
              )
            ),
            const SizedBox(height: 8),
            Text(
              watchlist[index][0],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFFAEBD7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
