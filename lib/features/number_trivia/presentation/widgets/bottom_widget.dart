import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';
import 'elevated_button.dart';

class BottomWidget extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String str;
    return Container(
      height: 200,
      child: Column(
        children: [
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'input a number',
              filled: true,
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _addingConcreteEvent(
              context: context,
              numberString: str,
            ),
            onChanged: (value) {
              str = value;
            },
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: ElevButton(
                  label: 'Search',
                  onPressed: () => _addingConcreteEvent(
                    context: context,
                    numberString: str,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevButton(
                  label: 'Random',
                  onPressed: () {
                    BlocProvider.of<NumberTriviaBloc>(context)
                        .add(GetTriviaForRandomNumber());
                  },
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _addingConcreteEvent({BuildContext context, String numberString}) {
    _controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(numberString ?? '0'));
  }
}
