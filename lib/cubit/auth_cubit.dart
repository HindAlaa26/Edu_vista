import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import '../services/pref_service.dart';
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
          const SnackBar(
            content: Text('No user found for that email.'),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
          ),
        );
      } else if (e.code == 'user-disabled') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User Disabled'),
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid Credential'),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
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
        // credentials.user!.updatePhotoURL(
        //     "https://icons.veryicon.com/png/o/system/crm-android-app-icon/app-icon-person.png");
        userCreate(
          email: emailController.text,
          name: nameController.text,
          uId: credentials.user!.uid,
        );
        if (!context.mounted) return false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully'),
          ),
        );
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return false;
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The account already exists for that email.'),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up Exception $e'),
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
        const SnackBar(
          content: Text('Password reset email sent.'),
        ),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send reset email: ${e.message}'),
        ),
      );
      return false;
    } catch (e) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
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
        print('>>>>>Image uploaded: $downloadUrl');
        PreferencesService.profileImage = downloadUrl;
        print("........................${PreferencesService.profileImage}");
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
        const SnackBar(
          content: Text('Logged out successfully'),
        ),
      );
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: $e'),
        ),
      );
      return false;
    }
  }
}
