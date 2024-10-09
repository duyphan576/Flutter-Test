import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/algorithm_bloc.dart';
import '../blocs/algorithm_event.dart';
import '../blocs/algorithm_state.dart';

class AlgorithmScreen extends StatelessWidget {
  const AlgorithmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final algorithmBloc = BlocProvider.of<AlgorithmBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Algorithm'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                algorithmBloc.add(FetchDataEvent());
              },
              child: const Text('Fetch and Process Data'),
            ),
            const SizedBox(height: 20),
            BlocBuilder<AlgorithmBloc, AlgorithmState>(
              builder: (context, state) {
                if (state is AlgorithmInitial) {
                  return const Text('Press the button to start.');
                } else if (state is AlgorithmLoading) {
                  return const CircularProgressIndicator();
                } else if (state is AlgorithmLoaded) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Result $index: ${state.results[index]}'),
                        );
                      },
                    ),
                  );
                } else if (state is AlgorithmError) {
                  return Text('Error: ${state.error}');
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
