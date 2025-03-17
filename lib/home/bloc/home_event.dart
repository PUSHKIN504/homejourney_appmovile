abstract class HomeEvent {}

class LoadHomeData extends HomeEvent {}

class RefreshHomeData extends HomeEvent {}

class SearchItems extends HomeEvent {
  final String query;
  
  SearchItems(this.query);
}

