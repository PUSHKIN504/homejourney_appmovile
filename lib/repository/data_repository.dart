class DataRepository {
  Future<List<String>> fetchItems() async {
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];
  }
}

