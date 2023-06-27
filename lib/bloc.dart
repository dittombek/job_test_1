import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

final dio = Dio();

class BlocEvent {}

class HttpRequest extends BlocEvent {}

class DioRequest extends BlocEvent {}

class BlocState {}

class Initial extends BlocState {}

class DataProfile extends BlocState {
  DataProfile(this.profile);

  final List profile;
}

class TotalElixirs extends BlocState {
  TotalElixirs(this.elixirs);

  final int elixirs;
}

class Failure extends BlocState {}

class UseBloc extends Bloc<BlocEvent, BlocState> {
  UseBloc() : super(Initial()) {
    on<HttpRequest>((event, emit) async {
      final url = Uri.https('wizard-world-api.herokuapp.com', 'wizards');
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        emit(Failure());
      }

      final dataResponse = json.decode(response.body);
      var totalElixirs = 0;

      for (var dataItem in dataResponse) {
        totalElixirs += dataItem['elixirs'].length as int;
      }

      emit(DataProfile(dataResponse));
      emit(TotalElixirs(totalElixirs));
    });
    on<DioRequest>((event, emit) async {
      try {
        final response =
            await dio.get('https://wizard-world-api.herokuapp.com/wizards');

        final dataResponse = response.data;
        var totalElixirs = 0;

        for (var dataItem in dataResponse) {
          totalElixirs += dataItem['elixirs'].length as int;
        }

        emit(DataProfile(dataResponse));
        emit(TotalElixirs(totalElixirs));
      } catch (e) {
        emit(Failure());
      }
    });
  }
}


  // final StreamController _inputController = StreamController();
  // StreamSink get inputSink => _inputController.sink;

  // final StreamController _outputController = StreamController();
  // StreamSink get outputSink => _outputController.sink;

  // Stream get output => _outputController.stream;

  // UseBloc() {
  //   _inputController.stream.listen(
  //     (event) {
  //       outputSink.add(event);
  //     },
  //   );
  // }

  // void dispose() {
  //   _inputController.close();
  //   _outputController.close();
  // }
