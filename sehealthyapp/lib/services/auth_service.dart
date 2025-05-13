import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔐 Register dengan Email & Password
  Future<String?> registerWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      // Buat akun di Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Update nama di Firebase Auth
      await user!.updateDisplayName(name);

      // Simpan data user ke Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'fullName': name,
        'email': email,
        'uid': user.uid,
      });

      return null; // null artinya sukses
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 🔑 Login dengan Email & Password
  Future<String?> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 🔐 Login dengan Google
  Future<String?> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut(); // Tambahkan ini sebelum signIn()

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return 'Login dibatalkan';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login ke Firebase dengan kredensial Google
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // Jika user baru, simpan data ke Firestore
      final userDoc = await _firestore.collection('users').doc(user!.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': user.displayName,
          'email': user.email,
          'uid': user.uid,
        });
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // 🚪 Logout
  Future<void> logout() async {
    await _auth.signOut();
    await GoogleSignIn().signOut(); // Jika login via Google
  }

  // 👤 Ambil user yang sedang login
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
