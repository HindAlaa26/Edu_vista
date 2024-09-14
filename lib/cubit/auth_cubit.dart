import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import '../services/pref_service.dart';
import '../shared_component/default_text.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);
  UserModel? model;
  Future<bool> login({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    try {
      var credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if (credentials.user != null) {
        emit(LoginSuccess());
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return false;
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: textInApp(
                text: 'No user found for that email.', color: Colors.white),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: textInApp(
                text: 'Wrong password provided for that user.',
                color: Colors.white),
          ),
        );
      } else if (e.code == 'user-disabled') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: textInApp(text: 'User Disabled', color: Colors.white),
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: textInApp(text: 'Invalid Credential', color: Colors.white),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: textInApp(text: 'Something went wrong', color: Colors.white),
        ),
      );
    }
    return false;
  }

  Future<bool> signUp({
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    try {
      var credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (credentials.user != null) {
        credentials.user!.updateDisplayName(nameController.text);
        userCreate(
          email: emailController.text,
          name: nameController.text,
          uId: credentials.user!.uid,
        );
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: textInApp(
                text: 'Account created successfully', color: Colors.white),
          ),
        );
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return false;
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orange,
            content: textInApp(
                text: 'The password provided is too weak.',
                color: Colors.white),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: textInApp(
                text: 'The account already exists for that email.',
                color: Colors.white),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: textInApp(text: 'Sign up Exception $e', color: Colors.white),
        ),
      );
    }
    return false;
  }

  Future<bool> sendPasswordResetEmail({
    required BuildContext context,
    required TextEditingController emailController,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: textInApp(
              text: 'Password reset email sent.', color: Colors.white),
        ),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: textInApp(
              text: 'Failed to send reset email: ${e.message}',
              color: Colors.white),
        ),
      );
      return false;
    } catch (e) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: textInApp(text: 'Unexpected error: $e', color: Colors.white),
        ),
      );
      return false;
    }
  }

  void userCreate({
    required String name,
    required String email,
    required String uId,
  }) {
    UserModel model = UserModel(
        name: name,
        email: email,
        uid: uId,
        image:
            "https://icons.veryicon.com/png/o/system/crm-android-app-icon/app-icon-person.png");
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessfully());
    }).catchError((error) {
      emit(CreateUserFailed(error.toString()));
    });
  }

  Future<void> fetchUserData() async {
    emit(UserLoading());
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(UserError('No user is currently logged in.'));
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userDoc.exists) {
        UserModel userModel = UserModel.fromJson({
          'id': userDoc.id,
          ...userDoc.data() as Map<String, dynamic>,
        });

        emit(UserLoaded(userModel));
      } else {
        emit(UserError('User document does not exist.'));
      }
    } catch (e) {
      emit(UserError('Error fetching user data: $e'));
    }
  }

  Future<void> uploadImage(BuildContext context) async {
    emit(ImageUploading());

    var imageResult = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    if (imageResult != null) {
      var storageRef = FirebaseStorage.instance
          .ref('images/${imageResult.files.first.name}');
      var uploadResult = await storageRef.putData(
        imageResult.files.first.bytes!,
        SettableMetadata(
          contentType: 'image/${imageResult.files.first.name.split('.').last}',
        ),
      );

      if (uploadResult.state == TaskState.success) {
        var downloadUrl = await uploadResult.ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"image": downloadUrl});
        PreferencesService.profileImage = downloadUrl;
        fetchUserData();
      } else {
        emit(UserError('Image upload failed.'));
      }
    } else {
      print('No file selected');
      emit(UserError('No file selected.'));
    }
  }

  Future<void> updateUserData(
      {required String name, required BuildContext context}) async {
    emit(UserUpdating());
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'name': name,
      });
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
      fetchUserData();
    } catch (e) {
      emit(UserError('Failed to update user data: $e'));
    }
  }

  Future<bool> deleteUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content:
              textInApp(text: 'Logged out successfully', color: Colors.white),
        ),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content:
              textInApp(text: 'Error logging out: $e', color: Colors.white),
        ),
      );
      return false;
    }
  }
}
