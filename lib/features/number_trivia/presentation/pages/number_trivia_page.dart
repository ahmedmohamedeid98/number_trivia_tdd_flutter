import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: SingleChildScrollView(child: buildBody()),
    );
  }

  BlocProvider<NumberTriviaBloc> buildBody() {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BodyWidget(),
            const SizedBox(
              height: 20,
            ),
            BottomWidget(),
          ],
        ),
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
      builder: (context, state) {
        if (state is Empty) {
          return DisplayMessage(
            message: 'Start Searching!',
          );
        } else if (state is Loading) {
          return LoadingWidget();
        } else if (state is Loaded) {
          return LoadedWidget(
            numberTrivia: state.trivia,
          );
        } else if (state is Error) {
          return DisplayMessage(
            message: state.message,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
