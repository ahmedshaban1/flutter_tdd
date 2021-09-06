import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tddcourse/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:tddcourse/features/number_trivia/presentation/widgets/message_display.dart';
import 'package:tddcourse/injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      builder: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: "Start Searching!",
                    );
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.errorMessage,
                    );
                  } else if (state is Loaded) {
                    return TriviaDisplay(
                      numberTrivia: state.numberTrivia,
                    );
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else {
                    return Placeholder();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TriviaControls()
            ],
          ),
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String inputString;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            inputString = value;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: "Input number"),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: RaisedButton(
              child: Text("Search"),
              color: Theme.of(context).accentColor,
              textTheme: ButtonTextTheme.primary,
              onPressed: () {
                dispatchConcert(inputString);
              },
            )),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: RaisedButton(
              child: Text("Random number"),
              onPressed: () {
                dispatchRandom();
              },
            )),
          ],
        )
      ],
    );
  }

  void dispatchConcert(String number){
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(GetTriviaForConcertNumberEvent(number));
  }
  void dispatchRandom(){
    BlocProvider.of<NumberTriviaBloc>(context).dispatch(GetRandomNumberTriviaEvent());

  }
}
