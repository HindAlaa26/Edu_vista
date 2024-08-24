import 'package:flutter/material.dart';

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

final class CreateUserFailed extends UserState {
  final String error;

  CreateUserFailed(this.error);
}

// logout State
final class LogoutState extends AuthState {}

final class LogoutSuccess extends LogoutState {}

final class LogoutFailed extends LogoutState {
  final String error;

  LogoutFailed(this.error);
}
