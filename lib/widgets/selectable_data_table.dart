import 'package:flutter/material.dart';

class SelectableDataTable<T> extends StatefulWidget {
  final List<T> data;
  final List<Map<String, dynamic>> columns;
  final List<T> selectedItems;
  final Function(List<T>) onSelectionChanged;
  final String Function(T, String) getValue;
  final int? maxSelections;

  const SelectableDataTable({
    Key? key,
    required this.data,
    required this.columns,
    required this.selectedItems,
    required this.onSelectionChanged,
    required this.getValue,
    this.maxSelections,
  }) : super(key: key);

  @override
  State<SelectableDataTable<T>> createState() => _SelectableDataTableState<T>();
}

class _SelectableDataTableState<T> extends State<SelectableDataTable<T>> {
  late List<T> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.selectedItems);
  }

  @override
  void didUpdateWidget(SelectableDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItems != widget.selectedItems) {
      _selectedItems = List.from(widget.selectedItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              const DataColumn(
                label: Text(''),
              ),
              ...widget.columns.map((column) => DataColumn(
                label: Text(
                  column['label'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )),
            ],
            rows: widget.data.map((item) {
              final isSelected = _selectedItems.contains(item);
              return DataRow(
                selected: isSelected,
                onSelectChanged: (selected) {
                  if (selected == null) return;
                  
                  setState(() {
                    if (selected) {
                      if (widget.maxSelections != null && 
                          _selectedItems.length >= widget.maxSelections! && 
                          !isSelected) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Solo puede seleccionar un máximo de ${widget.maxSelections} elementos'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      _selectedItems.add(item);
                    } else {
                      _selectedItems.remove(item);
                    }
                  });
                  
                  widget.onSelectionChanged(_selectedItems);
                },
                cells: [
                  DataCell(
                    Checkbox(
                      value: isSelected,
                      onChanged: (selected) {
                        if (selected == null) return;
                        
                        setState(() {
                          if (selected) {
                            if (widget.maxSelections != null && 
                                _selectedItems.length >= widget.maxSelections! && 
                                !isSelected) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Solo puede seleccionar un máximo de ${widget.maxSelections} elementos'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            _selectedItems.add(item);
                          } else {
                            _selectedItems.remove(item);
                          }
                        });
                        
                        widget.onSelectionChanged(_selectedItems);
                      },
                    ),
                  ),
                  ...widget.columns.map((column) => DataCell(
                    Text(widget.getValue(item, column['field'] as String)),
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

