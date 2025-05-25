import 'package:cloud_firestore/cloud_firestore.dart';

class CheckupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getNextCheckupForUser(String userId) async {
    final now = DateTime.now();

    // Query checkups untuk user, tanggal >= sekarang, urut tanggal ascending, limit 1
    final querySnapshot =
        await _firestore
            .collection('checkups')
            .where(
              'userId',
              isEqualTo: userId,
            ) // pastikan ada field userId di document
            .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
            .orderBy('date')
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    }
    return null;
  }
}
