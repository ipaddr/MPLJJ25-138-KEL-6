import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'education_edit.dart';
import 'education_add.dart';

class EducationMaterialPage extends StatelessWidget {
  const EducationMaterialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: EducationMaterialPageBody());
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
  List<DocumentSnapshot> _allContents = [];
  List<DocumentSnapshot> _filteredContents = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _fetchContents();
  }

  Future<void> _fetchContents() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('educational_contents')
            .orderBy('title')
            .get();

    setState(() {
      _allContents = snapshot.docs;
      _filteredContents = _allContents;
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContents =
          _allContents.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final title = data['title']?.toString().toLowerCase() ?? '';
            final type = data['type']?.toString().toLowerCase() ?? '';
            return title.contains(query) || type.contains(query);
          }).toList();
    });
  }

  void _onAddNew() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EducationAddPage()),
    ).then((_) => _fetchContents());
  }

  void _onEdit(DocumentSnapshot doc) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EducationEditPage(document: doc)),
    ).then((_) => _fetchContents());
  }

  void _onDelete(DocumentSnapshot doc) {
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
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('educational_contents')
                      .doc(doc.id)
                      .delete();
                  Navigator.of(context).pop();
                  _fetchContents();
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
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
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
                          final doc = _filteredContents[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final title = data['title'] ?? '';
                          final type = data['type'] ?? '';
                          final detail = data['detail'] ?? '';
                          final imageUrl = data['imageUrl'];

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
                                // Thumbnail
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                    image:
                                        imageUrl != null
                                            ? DecorationImage(
                                              image: NetworkImage(imageUrl),
                                              fit: BoxFit.cover,
                                            )
                                            : null,
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
                                        title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$type • $detail',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Edit & Delete
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _onEdit(doc),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () => _onDelete(doc),
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
