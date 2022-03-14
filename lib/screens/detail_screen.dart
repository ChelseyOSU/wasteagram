import 'package:flutter/material.dart';
import '../models/food_waste_post.dart';

class DetailScreen extends StatefulWidget {
  FoodWastePost post;
  DetailScreen({required this.post});
  
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(title: Text('Wastegram'), centerTitle: true),
      body: Column(
        children: <Widget> [
          Container(
            child: Text('${widget.post.date}')
          ),
          Image.network('${widget.post.imageUrl}'),
          Text('${widget.post.numOfEntities} items'),
          Text('Location: (${widget.post.latitude}, ${widget.post.longitude})')
        ]
      )
    );
  }
}