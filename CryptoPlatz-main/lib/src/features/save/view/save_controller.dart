import 'package:crypto_platz/src/app/repositories/crypto_repository.dart';
import 'package:crypto_platz/src/app/theme/app_colors.dart';
import 'package:crypto_platz/src/app/theme/app_fonts.dart';
import 'package:crypto_platz/src/features/save/bloc/save_cubit.dart';
import 'package:crypto_platz/src/features/save/view/confirmation_dialog.dart';
import 'package:crypto_platz/src/features/tabs/bloc/tabs_cubit.dart';
import 'package:crypto_platz/src/widgets/info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveController extends StatelessWidget {
  const SaveController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaveCubit>(
        create: (context) =>
            SaveCubit(cryptoRepository: context.read<CryptoRepository>()),
        child: const _SaveView());
  }
}

class _SaveView extends StatefulWidget {
  const _SaveView({Key? key}) : super(key: key);

  @override
  State<_SaveView> createState() => _SaveViewState();
}

class _SaveViewState extends State<_SaveView> {
  late TextEditingController dataController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();

    dataController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TabsCubit, int>(
      listener: (context, state) {
        if (state == 1) {
          dataController.clear();
          passwordController.clear();
          confirmPasswordController.clear();

          context.read<SaveCubit>().clear();
        }
      },
      child: BlocListener<SaveCubit, SaveState>(
        listenWhen: (previous, current) =>
            previous.showDialog != current.showDialog ||
            previous.isConnectionError != current.isConnectionError ||
            previous.isPasswordError != current.isPasswordError,
        listener: (context, state) async {
          if (state.showDialog) {
            dataController.clear();
            passwordController.clear();
            confirmPasswordController.clear();

            await showDialog(
                context: context,
                useSafeArea: false,
                builder: (context) => const ConfirmationDialog());
          }
          if (state.isConnectionError) {
            showDialog(
                context: context,
                builder: (context) => const InfoDialog(type: DialogType.error));
          }
          if (state.isPasswordError) {
            showDialog(
                context: context,
                builder: (context) =>
                    const InfoDialog(type: DialogType.password));
          }
        },
        child: SafeArea(
            child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Save',
                              style: AppFonts.custom(
                                  fontSize: 32, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Let\'s protect you',
                              style: AppFonts.custom(fontSize: 16)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 16, right: 32, bottom: 12),
                      child: Column(
                        children: [
                          BlocBuilder<SaveCubit, SaveState>(
                              buildWhen: (previous, current) =>
                                  previous.data != current.data,
                              builder: (context, state) {
                                return TextField(
                                  controller: dataController,
                                  maxLines: 8,
                                  minLines: 8,
                                  decoration: InputDecoration(
                                      hintText:
                                          'Type here the information you want to protect',
                                      contentPadding: const EdgeInsets.all(16),
                                      focusedBorder: _getInputBorder(),
                                      enabledBorder: _getInputBorder()),
                                  onChanged: (String value) {
                                    context.read<SaveCubit>().changeData(value);
                                  },
                                );
                              }),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text('Use password to encrypt',
                                style: AppFonts.custom(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                          ),
                          BlocBuilder<SaveCubit, SaveState>(
                              buildWhen: (previous, current) =>
                                  previous.password != current.password ||
                                  previous.isPasswordValid !=
                                      current.isPasswordValid ||
                                  previous.showPassword != current.showPassword,
                              builder: (context, state) {
                                return TextField(
                                  controller: passwordController,
                                  obscureText: !state.showPassword,
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          context
                                              .read<SaveCubit>()
                                              .showPassword(
                                                  !state.showPassword);
                                        },
                                        child: Image.asset(
                                            height: 25,
                                            'assets/images/${state.showPassword ? 'show_password' : 'hide_password'}.png'),
                                      ),
                                      hintText: 'Password',
                                      errorText: !state.isPasswordValid
                                          ? 'Password is required'
                                          : null,
                                      contentPadding: const EdgeInsets.all(16),
                                      focusedBorder: _getInputBorder(),
                                      border: _getInputBorder(),
                                      errorBorder:
                                          _getInputBorder(color: AppColors.red),
                                      enabledBorder: _getInputBorder()),
                                  onChanged: (String value) {
                                    context
                                        .read<SaveCubit>()
                                        .changePassword(value);
                                  },
                                );
                              }),
                          const SizedBox(height: 10),
                          BlocBuilder<SaveCubit, SaveState>(
                              buildWhen: (previous, current) =>
                                  previous.confirmPassword !=
                                      current.confirmPassword ||
                                  previous.isConfirmPasswordValid !=
                                      current.isConfirmPasswordValid,
                              builder: (context, state) {
                                return TextField(
                                  controller: confirmPasswordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: 'Repeat password',
                                      errorText: !state.isConfirmPasswordValid
                                          ? 'Passwords don\'t match'
                                          : null,
                                      contentPadding: const EdgeInsets.all(16),
                                      focusedBorder: _getInputBorder(),
                                      border: _getInputBorder(),
                                      errorBorder:
                                          _getInputBorder(color: AppColors.red),
                                      enabledBorder: _getInputBorder()),
                                  onChanged: (String value) {
                                    context
                                        .read<SaveCubit>()
                                        .changeConfirmPassword(value);
                                  },
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    width: double.maxFinite,
                    child: BlocBuilder<SaveCubit, SaveState>(
                        buildWhen: (previous, current) =>
                            previous.isConfirmPasswordValid !=
                                current.isConfirmPasswordValid ||
                            previous.isPasswordValid != current.isPasswordValid,
                        builder: (context, state) {
                          return TextButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColors.red,
                                  disabledBackgroundColor:
                                      AppColors.red.withOpacity(0.5),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              onPressed: state.isConfirmPasswordValid &&
                                      state.isPasswordValid
                                  ? () async {
                                      FocusScope.of(context).unfocus();

                                      bool result = true;

                                      if (passwordController.text.isEmpty) {
                                        result = await showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => InfoDialog(
                                                type: DialogType.save,
                                                onConfirm: () {
                                                  context
                                                      .read<SaveCubit>()
                                                      .save();
                                                }));
                                      }

                                      if (result) {
                                        context.read<SaveCubit>().save();
                                      }
                                    }
                                  : null,
                              child: Text('Save',
                                  style: AppFonts.custom(
                                      fontSize: 16, color: Colors.white)));
                        }),
                  ))
            ],
          ),
        )),
      ),
    );
  }

  OutlineInputBorder _getInputBorder({Color color = AppColors.lightGrey}) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: 1));
  }
}
