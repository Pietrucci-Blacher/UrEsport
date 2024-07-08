import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final List<String> availableTags;
  final List<String> selectedTags;
  final List<String> sortOptions;
  final String currentSortOption;
  final Function(List<String>, String) onFilterChanged;

  const FilterButton({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    required this.sortOptions,
    required this.currentSortOption,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: FloatingActionButton.extended(
        onPressed: () => _showFilterBottomSheet(context),
        label: Text(
          'Filtres (${selectedTags.length})',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 13, // Taille de police réduite
          ),
        ),
        icon: Icon(Icons.filter_list,
            color: Colors.black87, size: 18), // Taille d'icône réduite
        backgroundColor: Colors.white,
        elevation: 2,
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(
        availableTags: availableTags,
        selectedTags: selectedTags,
        sortOptions: sortOptions,
        currentSortOption: currentSortOption,
        onFilterChanged: onFilterChanged,
      ),
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final List<String> availableTags;
  final List<String> selectedTags;
  final List<String> sortOptions;
  final String currentSortOption;
  final Function(List<String>, String) onFilterChanged;

  const FilterBottomSheet({
    super.key,
    required this.availableTags,
    required this.selectedTags,
    required this.sortOptions,
    required this.currentSortOption,
    required this.onFilterChanged,
  });

  @override
  FilterBottomSheetState createState() => FilterBottomSheetState();
}

class FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<String> _selectedTags;
  String _searchQuery = '';
  late String _sortOption;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.selectedTags);
    _sortOption = widget.currentSortOption;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildTagList(),
                  const SizedBox(height: 24),
                  _buildSortOptions(),
                  const SizedBox(height: 24),
                  _buildApplyButton(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Filtrer et trier', style: Theme.of(context).textTheme.titleLarge),
        TextButton.icon(
          onPressed: _resetFilters,
          icon: const Icon(Icons.refresh),
          label: const Text('Réinitialiser'),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Rechercher des tags',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
    );
  }

  Widget _buildTagList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FILTRER PAR TAGS',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.availableTags
              .where((tag) =>
                  tag.toLowerCase().contains(_searchQuery.toLowerCase()))
              .map((tag) => FilterChip(
                    label: Text(tag),
                    selected: _selectedTags.contains(tag),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                    selectedColor:
                        Theme.of(context).primaryColor.withOpacity(0.3),
                    checkmarkColor: Theme.of(context).primaryColor,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSortOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TRIER', style: Theme.of(context).textTheme.titleMedium),
        ...widget.sortOptions.map((option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _sortOption,
              onChanged: (value) {
                setState(() {
                  _sortOption = value!;
                });
              },
              activeColor: Theme.of(context).primaryColor,
            )),
      ],
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.onFilterChanged(_selectedTags, _sortOption);
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text('Appliquer les filtres'),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedTags.clear();
      _searchQuery = '';
      _sortOption = widget.sortOptions.first;
    });
  }
}
