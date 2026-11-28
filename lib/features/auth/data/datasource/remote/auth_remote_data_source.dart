import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserCredential> signInWithGoogle();

  Future<UserCredential> register({
    required String email,
    required String password,
  });

  Future<void> updateProfile({String? displayName, String? photoURL});

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signOut();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthFirebaseDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  const AuthFirebaseDataSourceImpl(this._auth, this._googleSignIn);

  @override
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) => _auth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      return _auth.signInWithPopup(GoogleAuthProvider());
    }
    await _googleSignIn.initialize();
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> register({
    required String email,
    required String password,
  }) => _auth.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<void> updateProfile({String? displayName, String? photoURL}) => _auth
      .currentUser!
      .updateProfile(displayName: displayName, photoURL: photoURL);

  @override
  Future<void> sendPasswordResetEmail({required String email}) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }
}
