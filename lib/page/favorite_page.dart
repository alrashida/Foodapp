
import 'package:flutter/material.dart';
import 'package:foodapp_skl/database/dbhelper.dart';
import 'package:foodapp_skl/model/response_filter.dart';
import 'package:foodapp_skl/ui/list_meals.dart';

class FavoritePage extends StatefulWidget {
  final int indexNav;

  const FavoritePage({Key? key, required this.indexNav}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  int currentIndex = 0;
  String category = "seafoood";
  ResponseFilter? responseFilter;
  bool isLoading = true;

  var db = DBHelper();

  void fetcDataMeals() async {
    var data = await db.gets(category);
    setState(() {
      responseFilter = ResponseFilter(meals: data);
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetcDataMeals();
    currentIndex = widget.indexNav;
  }

  @override
  Widget build(BuildContext context) {
    var listNav = [listMeals(responseFilter!), listMeals(responseFilter!)];
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite receipe'),
        backgroundColor: Colors.brown,
        actions: <Widget>[],
      ),
      body: Center(
        child: isLoading == false
            ? listNav[currentIndex]
            : CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood,),label: "Seafood"),
          BottomNavigationBarItem(icon: Icon(Icons.cake,),label: "Cake"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
            index == 0 ? category = 'seafood' : category = 'Dessert';
          });
          fetcDataMeals();
        },
      ),
    );
  }
}
