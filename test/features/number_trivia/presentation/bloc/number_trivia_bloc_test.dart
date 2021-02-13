import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_number_trivia/core/error/failures.dart';
import 'package:tdd_number_trivia/core/usecase/usecase.dart';
import 'package:tdd_number_trivia/core/utils/input_converter.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockInputConverter = MockInputConverter();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(tNumberString))
            .thenReturn(Right(tNumberParsed));
    test(
        'should call the InputConverter to validate and convert string to unsigned int',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] state with message when input is invalid',
        () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      /// Here we are going to put the assert before act WHY?
      /// because when we adding a new event to the bloc it is possible
      /// to emit the state before the assert begin to execute,
      /// therefore we will not catch the emitted state.
      /// so it is more safer put the assert before act also we
      /// certain that the asset will wait at least 30 seconds
      /// for the bloc to emit state.

      // assert later
      final expected = [
        // Empty(),
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];

      /// in ^v1.0.0 blocs extend Stream so there is no longer a state stream property.
      /// The state property now refers to the bloc's current state.
      /// expectLater(bloc.state, emitsInOrder(expected)); X
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test('should get data from the concrete use case', () async {
      /// we told the mocked GetConcreteNumberTrivia use if any one called you then answer him
      /// with NumberTrivia model
      ///
      /// pass a event to the bloc told him we need a NumberTrivia model for that string number
      /// and wait until the usecase to called.
      ///
      /// verify that the usecase was called with parsed integer number

      // arrange

      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // act
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert
      final expected = [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit [Loading, Error] when data is not gotten successfully from server',
        () {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert
      final expected = [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });

    test(
        'should emit [Loading, Error] when data is not gotten successfully from cache',
        () {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia.call(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert
      final expected = [
        Loading(),
        Error(message: CACHED_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: 'test', number: 1);

    test('should get data from the random use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia.call(NoParams()))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(NoParams()));
      // act
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetRandomNumberTrivia.call(NoParams()))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert
      final expected = [
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] when data is not gotten successfully from server',
        () {
      // arrange
      when(mockGetRandomNumberTrivia.call(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert
      final expected = [
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'should emit [Loading, Error] when data is not gotten successfully from cache',
        () {
      // arrange
      when(mockGetRandomNumberTrivia.call(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert
      final expected = [
        Loading(),
        Error(message: CACHED_FAILURE_MESSAGE),
      ];
      expectLater(bloc, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
