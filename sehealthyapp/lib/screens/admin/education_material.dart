import 'package:flutter/material.dart';
import 'education_edit.dart';
import 'education_add.dart';

class EducationMaterialPage extends StatelessWidget {
  const EducationMaterialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: const EducationMaterialPageBody());
  }
}

class EducationMaterialPageBody extends StatefulWidget {
  const EducationMaterialPageBody({Key? key}) : super(key: key);

  @override
  State<EducationMaterialPageBody> createState() =>
      _EducationMaterialPageBodyState();
}

class _EducationMaterialPageBodyState extends State<EducationMaterialPageBody> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _allContents = [
    {
      'title': 'Healthy Diet Guidelines',
      'category': 'Diet',
      'detail': '10 min read',
    },
    {
      'title': 'Daily Exercise Routine',
      'category': 'Lifestyle',
      'detail': 'Video',
    },
  ];

  List<Map<String, String>> _filteredContents = [];

  @override
  void initState() {
    super.initState();
    _filteredContents = List.from(_allContents);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContents =
          _allContents.where((content) {
            final titleLower = content['title']!.toLowerCase();
            final categoryLower = content['category']!.toLowerCase();
            return titleLower.contains(query) || categoryLower.contains(query);
          }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onAddNew() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EducationAddPage()),
    );
  }

  void _onEdit(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EducationEditPage()),
    );
  }

  void _onDelete(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text(
              'Are you sure you want to delete this content?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Cancel
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _filteredContents.removeAt(index);
                  });
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Education Content',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _onAddNew,
                  icon: const Icon(Icons.add),
                  label: const Text('Add New'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search content...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // List konten edukasi
            Expanded(
              child:
                  _filteredContents.isEmpty
                      ? const Center(child: Text('No content found.'))
                      : ListView.separated(
                        itemCount: _filteredContents.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final content = _filteredContents[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Thumbnail Placeholder
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Title & subtitle
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        content['title'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${content['category']} • ${content['detail']}',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Edit & Delete Icons
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _onEdit(index),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => _onDelete(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
