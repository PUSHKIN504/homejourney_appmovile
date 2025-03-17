import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/data_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DataRepository dataRepository;
  
  HomeBloc({required this.dataRepository}) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<SearchItems>(_onSearchItems);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final items = await dataRepository.fetchItems();
      emit(HomeLoaded(items));
    } catch (e) {
      emit(HomeError('Failed to load data: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshHomeData(RefreshHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final items = await dataRepository.fetchItems();
      emit(HomeLoaded(items));
    } catch (e) {
      emit(HomeError('Failed to refresh data: ${e.toString()}'));
    }
  }

  Future<void> _onSearchItems(SearchItems event, Emitter<HomeState> emit) async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final filteredItems = currentState.items
          .where((item) => item.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(HomeLoaded(filteredItems));
    }
  }
}

