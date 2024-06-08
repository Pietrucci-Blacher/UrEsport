import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final Function(List<String>) onFilterChanged;

  const FilterButton({super.key, required this.onFilterChanged});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return FilterBottomSheet(onFilterChanged: onFilterChanged);
          },
        );
      },
      child: const Icon(Icons.filter_list),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final Function(List<String>) onFilterChanged;

  const FilterBottomSheet({super.key, required this.onFilterChanged});

  @override
  FilterBottomSheetState createState() => FilterBottomSheetState();
}

class FilterBottomSheetState extends State<FilterBottomSheet> {
  final List<String> _tags = ['FPS', 'MOBA', 'RPG', 'Sports', 'Simulation'];
  final List<String> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Tags',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: _tags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                widget.onFilterChanged(_selectedTags);
                Navigator.pop(context);
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
