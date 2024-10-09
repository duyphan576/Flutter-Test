import 'package:bloc/bloc.dart';
import 'algorithm_event.dart';
import 'algorithm_state.dart';
import '../repositories/algorithm_repository.dart';

class AlgorithmBloc extends Bloc<AlgorithmEvent, AlgorithmState> {
  final AlgorithmRepository repository;

  AlgorithmBloc(this.repository) : super(AlgorithmInitial()) {
    on<FetchDataEvent>((event, emit) async {
      emit(AlgorithmLoading());
      try {
        await repository.fetchData();
        List<int> results = repository.processQueries();
        emit(AlgorithmLoaded(results));
        await repository.sendResults(results);
      } catch (e) {
        emit(AlgorithmError(e.toString()));
      }
    });
  }
}
