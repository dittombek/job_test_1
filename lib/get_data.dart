import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_test_one/bloc.dart';

class GetData extends StatefulWidget {
  const GetData({super.key});

  @override
  State<GetData> createState() {
    return _GetDataState();
  }
}

class _GetDataState extends State<GetData> {
  List? listProfile;
  int? totalElixirs;
  UseBloc? bloc;
  var isLoading = true;

  @override
  void initState() {
    UseBloc bloc = BlocProvider.of<UseBloc>(context);
    bloc.add(HttpRequest());
    // bloc.add(DioRequest());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Test 1'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer(
              bloc: bloc,
              listener: (context, state) {
                if (state is DataProfile) {
                  listProfile = state.profile;
                } else if (state is TotalElixirs) {
                  totalElixirs = state.elixirs;
                } else if (state is Failure) {
                  isLoading = false;

                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Something Wrong!'),
                      content: const Text('Fail when fetch the data.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
                // return Text('$listProfile');
              },
              builder: (context, state) {
                // return Text('${listProfile?[0]['elixirs']}');
                if (listProfile != null && totalElixirs != null && isLoading) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.blueAccent,
                        child: Text('Total Elixirs = $totalElixirs'),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 600,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (listProfile != null)
                                for (final profile in listProfile!)
                                  Column(
                                    children: [
                                      Container(
                                        color: Colors.amber,
                                        child: Column(
                                          children: [
                                            Text('ID = ${profile['id']}'),
                                            Text(
                                                'First Name = ${profile['firstName']}'),
                                            Text(
                                                'Last Name =  ${profile['lastName']}'),
                                          ],
                                        ),
                                      ),
                                      for (final elixir in profile['elixirs'])
                                        Container(
                                          color: Colors.greenAccent,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Text('Elixir'),
                                                  const SizedBox(width: 16),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            'Elixir ID = ${elixir['id']}'),
                                                        Text(
                                                            'Elixir Name = ${elixir['name']}'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                          ),
                                        ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (listProfile == null &&
                    totalElixirs == null &&
                    isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Text('No Data');
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
