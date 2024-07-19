import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uresport/dashboard/bloc/dashboard_state.dart';
import 'package:uresport/dashboard/bloc/dashboard_event.dart';
import 'package:uresport/dashboard/bloc/dashboard_bloc.dart';

class FeatureFlippingScreen extends StatefulWidget {
  final DashboardLoaded state;

  const FeatureFlippingScreen({super.key, required this.state});

  @override
  FeatureFlippingScreenState createState() => FeatureFlippingScreenState();
}

class FeatureFlippingScreenState extends State<FeatureFlippingScreen> {
  String _sortColumn = 'name';
  bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                sortColumnIndex:
                    ['name', 'description', 'active'].indexOf(_sortColumn),
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: const Text('Name'),
                    onSort: (columnIndex, _) => _onSort('name'),
                  ),
                  DataColumn(
                    label: const Text('Description'),
                    onSort: (columnIndex, _) => _onSort('description'),
                  ),
                  DataColumn(
                    label: const Text('Active'),
                    onSort: (columnIndex, _) => _onSort('active'),
                  ),
                ],
                rows: widget.state.features.map((feature) {
                  return DataRow(cells: [
                    DataCell(Text(feature.name)),
                    DataCell(Text(feature.description)),
                    DataCell(Switch(
                      value: feature.active,
                      onChanged: (value) {
                        context
                            .read<DashboardBloc>()
                            .add(ToggleFeature(feature.id));
                      },
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onSort(String column) {
    if (_sortColumn == column) {
      setState(() {
        _sortAscending = !_sortAscending;
      });
    } else {
      setState(() {
        _sortColumn = column;
        _sortAscending = true;
      });
    }
  }
}
