import 'package:flutter/material.dart';

import '../../domain/entities/number_trivia.dart';

class LoadedWidget extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const LoadedWidget({
    Key key,
    @required this.numberTrivia,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            numberTrivia.number.toString(),
            style: TextStyle(
              fontSize: 50,
            ),
          ),
          Expanded(
              child: Center(
            child: SingleChildScrollView(
              child: Text(
                numberTrivia.text,
                style: TextStyle(
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ))
        ],
      ),
    );
  }
}
