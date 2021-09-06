import 'package:flutter/material.dart';
import 'package:tddcourse/features/number_trivia/domain/entities/number_trivia.dart';

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({@required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}


class TriviaDisplay extends StatelessWidget {
final NumberTrivia numberTrivia;

const TriviaDisplay({@required this.numberTrivia});

@override
Widget build(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height / 3,
    child: Column(
      children: [
        Text(numberTrivia.number.toString(),
        style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold),),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                numberTrivia.text,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}

