import 'package:flutter/material.dart';

class SearchSuggestionList extends StatelessWidget {
  final List<dynamic> suggestions;
  final Function(String) onTap;

  const SearchSuggestionList({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 250),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: suggestions.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = suggestions[index];
              return ListTile(
                leading: const Icon(Icons.location_on, color: Colors.red),
                title: Text(item['description']),
                onTap: () => onTap(item['place_id']),
              );
            },
          ),
        ),
      ),
    );
  }
}
