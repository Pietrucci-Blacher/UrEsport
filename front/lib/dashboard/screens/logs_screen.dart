import 'package:flutter/material.dart';
import 'package:uresport/core/models/log.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';

class LogsScreen extends StatefulWidget {
  final DashboardLoaded state;

  const LogsScreen({super.key, required this.state});

  @override
  LogsScreenState createState() => LogsScreenState();
}

class LogsScreenState extends State<LogsScreen> {
  String _sortColumn = 'date';
  bool _sortAscending = true;
  final List<String> _selectedTypes = [];

  @override
  Widget build(BuildContext context) {
    List<Log> filteredLogs = _filterAndSortLogs(widget.state.recentLogs);
    return Column(
      children: [
        _buildFilterChips(),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                sortColumnIndex:
                    ['date', 'type', 'tags', 'text'].indexOf(_sortColumn),
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: const Text('Date'),
                    onSort: (columnIndex, _) => _onSort('date'),
                  ),
                  DataColumn(
                    label: const Text('Type'),
                    onSort: (columnIndex, _) => _onSort('type'),
                  ),
                  const DataColumn(label: Text('Tags')),
                  const DataColumn(label: Text('Text')),
                ],
                rows: filteredLogs.map((log) {
                  return DataRow(cells: [
                    DataCell(Text(log.date.toIso8601String())),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color:
                              log.type == 'ERROR' ? Colors.red : Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          log.type,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    DataCell(Text(log.tags.join(', '))),
                    DataCell(Text(log.text)),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    List<String> allTypes = ['ERROR', 'INFO'];
    return Wrap(
      spacing: 8.0,
      children: allTypes.map((type) {
        return FilterChip(
          label: Text(type),
          selected: _selectedTypes.contains(type),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTypes.add(type);
              } else {
                _selectedTypes.remove(type);
              }
            });
          },
        );
      }).toList(),
    );
  }

  List<Log> _filterAndSortLogs(List<Log> logs) {
    List<Log> filteredLogs = logs.where((log) {
      return _selectedTypes.isEmpty || _selectedTypes.contains(log.type);
    }).toList();

    filteredLogs.sort((a, b) {
      var aValue = _getLogValue(a, _sortColumn);
      var bValue = _getLogValue(b, _sortColumn);
      return _sortAscending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    return filteredLogs;
  }

  dynamic _getLogValue(Log log, String column) {
    switch (column) {
      case 'date':
        return log.date;
      case 'type':
        return log.type;
      case 'tags':
        return log.tags.join(', ');
      case 'text':
        return log.text;
      default:
        return '';
    }
  }

  void _onSort(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
    });
  }
}
