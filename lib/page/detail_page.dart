import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:foodapp_skl/database/dbhelper.dart';
import 'package:foodapp_skl/model/meal_item.dart';
import 'package:foodapp_skl/model/response_detail.dart';

class DetailPage extends StatefulWidget {
  late  String? idMeal;

   DetailPage({Key? key,required this.idMeal}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late ResponseDetail? responseDetail;

  bool isLoading = true;
  bool isFavorite = false;
  var db = DBHelper();

  Future<ResponseDetail?> fetchDetail() async {
    try {
      var res = await http.get(Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/${widget.idMeal}'));
      isFavorite = await db.isFavorite(widget.idMeal);

      if (res.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(res.body);

        ResponseDetail data = ResponseDetail.fromJson(json);

        if (mounted) {
          setState(() {
            responseDetail = data;
            isLoading = true;
          });
        }
        return data;
      } else {
        return null;
      }
    } catch (e) {
      print('Field $e');
      return null;
    }
  }

  setFavorite() async {
    var db = DBHelper();
    Meal favorite = Meal(
        idMeal: responseDetail!.meals[0]['idMeal'],
        strMeal: responseDetail!.meals[0]['strMeal'],
        strInstructions: responseDetail!.meals[0]['strInstructions'],
        strMealThumb: responseDetail!.meals[0]['strMealThumb'],
        strCategory: responseDetail!.meals[0]['strCategory']);
    if (!isFavorite) {
      await db.insert(favorite);
      print('add data');
    } else {
      await db.delete(favorite);
      print('delete data');
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail '),
        actions: [
          IconButton(
              onPressed: () {
                setFavorite();
              },
              icon: isFavorite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border))
        ],
      ),
      body: Center(
        child: FutureBuilder<ResponseDetail?>(
            future: fetchDetail(),
            builder: (BuildContext context, snapShot) {
              if (snapShot.hasData) {
                return CircularProgressIndicator(
                  backgroundColor: Colors.brown,
                  strokeWidth: 5,
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child: Hero(
                          tag: '${responseDetail!.meals[0]['idMeal']}',
                          child: Material(
                            child: Image.network(
                                responseDetail!.meals[0]['strMealThumb']),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text('${responseDetail!.meals[0]['strMeal']}'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text('Instructions'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                            '${responseDetail!.meals[0]['strInstructions']}'),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
