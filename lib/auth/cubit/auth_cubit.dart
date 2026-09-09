import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthCubit({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(AuthInitial()) {
    // Listen to Firebase's own auth stream and mirror it into our state.
    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      // No manual emit needed on success — the authStateChanges
      // listener above will fire and emit AuthAuthenticated for us.
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Something went wrong'));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Something went wrong'));
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}