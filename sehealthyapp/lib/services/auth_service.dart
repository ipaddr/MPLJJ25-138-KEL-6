import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 🔐 Register dengan Email & Password
  Future<String?> registerWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload(); // Pastikan data user terupdate

        // Simpan data ke Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': name,
          'email': email,
          'uid': user.uid,
        });
      }

      return null; // sukses
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Email ini sudah digunakan. Silakan gunakan email lain.';
        case 'invalid-email':
          return 'Format email tidak valid.';
        case 'weak-password':
          return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
        default:
          return 'Terjadi kesalahan saat mendaftar: ${e.message}';
      }
    } catch (e) {
      return 'Terjadi kesalahan tidak terduga saat mendaftar.';
    }
  }

  // 🔑 Login dengan Email & Password
  Future<String?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null && !user.emailVerified) {
        await _auth.signOut(); // logout paksa
        return 'Email belum diverifikasi. Silakan cek kotak masuk atau spam kamu.';
      }

      return null; // sukses
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException code: ${e.code}'); // Debug info
      switch (e.code) {
        case 'user-not-found':
          return 'Akun dengan email ini tidak ditemukan.';
        case 'wrong-password':
          return 'Password yang kamu masukkan salah.';
        case 'invalid-email':
          return 'Format email tidak valid.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan login. Coba lagi nanti.';
        default:
          return 'Terjadi kesalahan saat login: ${e.message}';
      }
    } catch (e) {
      return 'Terjadi kesalahan tidak terduga saat login.';
    }
  }

  // 🔐 Login dengan Google
  Future<String?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // agar bisa pilih akun baru

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return 'Login dengan Google dibatalkan.';

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        return 'Gagal mendapatkan token autentikasi Google.';
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'fullName': user.displayName,
            'email': user.email,
            'uid': user.uid,
          });
        }
      }

      return null; // sukses
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException code: ${e.code}'); // Debug info
      return 'Login dengan Google gagal: ${e.message}';
    } catch (e) {
      return 'Terjadi kesalahan tidak terduga saat login dengan Google.';
    }
  }

  // 🚪 Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // 👤 Ambil user yang sedang login
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
