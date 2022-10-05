part of 'save_cubit.dart';

class SaveState extends Equatable {
  const SaveState(
      {this.data = '',
      this.password = '',
      this.confirmPassword = '',
      this.protectData = false,
      this.showDialog = false,
      this.isConnectionError = false,
      this.isPasswordError = false,
      this.showPassword = false});

  final String data;
  final String password;
  final String confirmPassword;
  final bool protectData;
  final bool showDialog;
  final bool isConnectionError;
  final bool isPasswordError;
  final bool showPassword;

  SaveState copyWith(
      {String? data,
      String? password,
      String? confirmPassword,
      bool? protectData,
      bool? showDialog,
      bool? isConnectionError,
      bool? isPasswordError,
      bool? showPassword}) {
    return SaveState(
        data: data ?? this.data,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        protectData: protectData ?? this.protectData,
        showDialog: showDialog ?? this.showDialog,
        isConnectionError: isConnectionError ?? this.isConnectionError,
        isPasswordError: isPasswordError ?? this.isPasswordError,
        showPassword: showPassword ?? this.showPassword);
  }

  bool get isPasswordValid => (password.isNotEmpty) || !protectData;

  bool get isConfirmPasswordValid => (confirmPassword == password ||
      (confirmPassword.isEmpty && password.isEmpty));

  @override
  List<Object> get props => [
        data,
        password,
        confirmPassword,
        protectData,
        showDialog,
        isConnectionError,
        isPasswordError,
        showPassword
      ];
}
