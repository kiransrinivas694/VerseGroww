import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final RxBool isLoading = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  // Client IDs for Google Sign In
  static const String webClientId =
      '719942468003-keq0j0jdp578p4uo1heena60l8pkp1ra.apps.googleusercontent.com';
  static const String androidClientId =
      '719942468003-7kn88vsdhiugndpu0d0d71aqascsp7h2.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: androidClientId, // Android client ID
    serverClientId:
        webClientId, // Web client ID (required for getting ID token)
    scopes: [
      'email',
      'profile',
      'openid',
    ],
  );

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      currentUser.value = session?.user;

      switch (event) {
        case AuthChangeEvent.signedIn:
          if (session != null) {
            Get.offAllNamed('/home');
          }
          break;
        case AuthChangeEvent.signedOut:
          Get.offAllNamed('/login');
          break;
        default:
          break;
      }
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      print('Starting Google Sign In process...');

      // Clear any existing sign-in
      await _googleSignIn.signOut();
      print('Cleared previous sign-in state');

      // Attempt sign in
      print('Attempting to sign in...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Google Sign In was cancelled';
      }

      print('Successfully signed in with Google account: ${googleUser.email}');

      // Get auth details from Google
      print('Getting authentication details...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print('Authentication completed');

      // Verify tokens
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      print('Access token obtained');

      if (idToken == null) {
        throw 'No ID Token found.';
      }
      print('ID token obtained');

      // Create Supabase credentials
      print('Attempting Supabase sign in...');
      final AuthResponse res =
          await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (res.user == null) {
        throw 'No user data returned from Supabase';
      }

      print('Successfully signed in with Supabase: ${res.user?.email}');
    } catch (error) {
      print('Detailed error information:');
      print('Error type: ${error.runtimeType}');
      print('Error message: $error');
      print('Stack trace:');
      print(StackTrace.current);

      String errorMessage = 'Failed to sign in with Google.';
      if (error.toString().contains('ApiException: 10')) {
        errorMessage =
            'Google Sign In configuration error. Please check app signing and package name.';
      } else if (error.toString().contains('network_error')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (error.toString().contains('popup_closed')) {
        errorMessage = 'Sign in cancelled by user.';
      } else if (error.toString().contains('No Access Token found')) {
        errorMessage = 'Failed to get access token. Please try again.';
      } else if (error.toString().contains('No ID Token found')) {
        errorMessage = 'Failed to get ID token. Please try again.';
      } else if (error.toString().contains('AuthApiException')) {
        errorMessage = 'Authentication error with Supabase. Please try again.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _googleSignIn.signOut(),
        Supabase.instance.client.auth.signOut(),
      ]);
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  bool get isAuthenticated => currentUser.value != null;
}
