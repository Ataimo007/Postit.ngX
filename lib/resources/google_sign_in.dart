import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:postit/app.dart';
import 'package:postit/models/login_user_entity.dart';

class GoogleLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'profile',
      'openid',
    ],
  );
  final service = ApiService.getService();

  static GoogleLogin login;

  static GoogleLogin getInstance() {
    if (login == null) login = GoogleLogin();
    return login;
  }

  static Future<LoginResponse> signInWithGoogle() async {
    final GoogleSignInAccount googleUser =
        await getInstance()._googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await getInstance()._auth.signInWithCredential(credential)).user;

      print("signed in " + user.toString());
      UserEntity postItUser = await logIntoPostIt(user);
      return LoginResponse(
          postItUser, "Login Successfully", true, LoginType.GOOGLE);
    }
    return LoginResponse(
        null, "Please Select an Account", false, LoginType.GOOGLE);
  }

  static void signOutGoogle() async {
    await getInstance()._googleSignIn.signOut();

    print("User Sign Out");
  }

  static Future<UserEntity> logIntoPostIt(FirebaseUser user) async {
    var split = user.displayName.split(" ");
    Map<String, dynamic> params = {
      "login_type": "social",
      "email": user.email,
      "first_name": split[0],
      "last_name": split[1],
      "phone": user.phoneNumber,
      "photo": user.photoUrl
    };
    print("Usesr params $params");
    return (await getInstance().service.login(params) as LoginUserEntity)
        .result;
  }
}
