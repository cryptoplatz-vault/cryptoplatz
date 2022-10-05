part of 'restore_cubit.dart';

class RestoreState extends Equatable {
  const RestoreState(
      {this.result = '',
      this.password = '',
      this.unlockCard = false,
      this.showDialog = false,
      this.isConnectionError = false,
      this.isPasswordError = false,
      this.showPassword = false});

  final String result;
  final String password;
  final bool unlockCard;
  final bool showDialog;
  final bool isConnectionError;
  final bool isPasswordError;
  final bool showPassword;

  RestoreState copyWith(
      {String? result,
      String? password,
      bool? unlockCard,
      bool? showDialog,
      bool? isConnectionError,
      bool? isPasswordError,
      bool? showPassword}) {
    return RestoreState(
        result: result ?? this.result,
        password: password ?? this.password,
        unlockCard: unlockCard ?? this.unlockCard,
        showDialog: showDialog ?? this.showDialog,
        isConnectionError: isConnectionError ?? this.isConnectionError,
        isPasswordError: isPasswordError ?? this.isPasswordError,
        showPassword: showPassword ?? this.showPassword);
  }

  @override
  List<Object> get props => [
        result,
        password,
        unlockCard,
        showDialog,
        isConnectionError,
        isPasswordError,
        showPassword
      ];
}
