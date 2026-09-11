import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;
  bool _googleSignInReady = false;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _googleAuthSub;

  AuthCubit({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(AuthInitial()) {
    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }

  Future<void> prepareGoogleSignIn() async {
    if (_googleSignInReady) return;
    await GoogleSignIn.instance.initialize(
      clientId:
          '1006763035386-51lrl2d9g6a8me137tc8i6it5ip7bj50.apps.googleusercontent.com',
    );
    _googleAuthSub = GoogleSignIn.instance.authenticationEvents.listen(
      _handleGoogleAuthEvent,
      onError: (Object e) => emit(AuthError('Google sign-in failed: $e')),
    );
    _googleSignInReady = true;
  }

  Future<void> _handleGoogleAuthEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    if (event is GoogleSignInAuthenticationEventSignIn) {
      final idToken = event.user.authentication.idToken;
      final credential = GoogleAuthProvider.credential(idToken: idToken);
      try {
        await _firebaseAuth.signInWithCredential(credential);
        // authStateChanges() listener above emits AuthAuthenticated for us.
      } on FirebaseAuthException catch (e) {
        emit(AuthError(e.message ?? 'Google sign-in failed'));
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
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

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      await prepareGoogleSignIn();
      await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        emit(AuthUnauthenticated());
      } else {
        emit(AuthError('Google sign-in failed: ${e.description ?? e.code}'));
      }
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> close() {
    _googleAuthSub?.cancel();
    return super.close();
  }
}