import 'package:flutter/material.dart';
import 'package:foodapp_skl/model/response_filter.dart';
import 'package:foodapp_skl/network/netclient.dart';
import 'package:foodapp_skl/page/favorite_page.dart';
import 'package:foodapp_skl/ui/list_meals.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  ResponseFilter? responseFilter;
  bool isloading = true;

  void fetchDataMeals() async {
    try {
      NetClient netclient = NetClient();
      var data = await netclient.fetchDataMeals(currentIndex);
      setState(() {
        responseFilter = data;
        isloading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void iniState() {
    super.initState();
    // TODO: implement initSate
    fetchDataMeals();
  }

  @override
  Widget build(BuildContext context) {
    var listNav = [
      listMeals(responseFilter),
      listMeals(responseFilter),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipe Apps'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FavoritePage(indexNav: currentIndex)));
            },
            icon: Icon(Icons.favorite_border),
          )
        ],
      ),
      body: Center(
        child: isloading == false
            ? listNav[currentIndex]
            : CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "Seafood"),
          BottomNavigationBarItem(icon: Icon(Icons.cake), label: "Dessert"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          fetchDataMeals();
        },
      ),
    );
  }
}
