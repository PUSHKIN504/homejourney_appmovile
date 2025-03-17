class DataRepository {
  // Simulate fetching data from an API
  Future<List<String>> fetchItems() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Return mock data
    return [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];
  }
}

