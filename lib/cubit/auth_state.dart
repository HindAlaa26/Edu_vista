import 'package:flutter/material.dart';

import '../models/user_model.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

// Signup State
final class SignupState extends AuthState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupFailed extends SignupState {}

// Login State
final class LoginState extends AuthState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {}

final class LoginFailed extends LoginState {
  final String error;

  LoginFailed(this.error);
}

// user State
final class UserState extends AuthState {}

final class CreateUserSuccessfully extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}

final class UserError extends UserState {
  final String message;
  UserError(this.message);
}

final class CreateUserFailed extends UserState {
  final String error;

  CreateUserFailed(this.error);
}

class UserUpdating extends AuthState {}

//profile image

class ImageUploading extends AuthState {}

class ImageUploadSuccess extends AuthState {
  final UserModel user;
  ImageUploadSuccess(this.user);
}

// logout State
final class LogoutState extends AuthState {}

final class LogoutSuccess extends LogoutState {}

final class LogoutFailed extends LogoutState {
  final String error;

  LogoutFailed(this.error);
}
