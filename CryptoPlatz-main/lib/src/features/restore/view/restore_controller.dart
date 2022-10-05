import 'package:crypto_platz/src/app/repositories/crypto_repository.dart';
import 'package:crypto_platz/src/app/theme/app_colors.dart';
import 'package:crypto_platz/src/app/theme/app_fonts.dart';
import 'package:crypto_platz/src/features/restore/bloc/restore_cubit.dart';
import 'package:crypto_platz/src/features/restore/view/data_dialog.dart';
import 'package:crypto_platz/src/features/tabs/bloc/tabs_cubit.dart';
import 'package:crypto_platz/src/widgets/info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestoreController extends StatelessWidget {
  const RestoreController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RestoreCubit>(
        create: (context) =>
            RestoreCubit(cryptoRepository: context.read<CryptoRepository>()),
        child: const _RestoreView());
  }
}

class _RestoreView extends StatefulWidget {
  const _RestoreView({Key? key}) : super(key: key);

  @override
  State<_RestoreView> createState() => _RestoreViewState();
}

class _RestoreViewState extends State<_RestoreView> {
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TabsCubit, int>(
      listener: (context, state) {
        if (state == 2) {
          passwordController.clear();

          context.read<RestoreCubit>().clear();
        }
      },
      child: BlocListener<RestoreCubit, RestoreState>(
        listenWhen: (previous, current) =>
            previous.showDialog != current.showDialog ||
            previous.isConnectionError != current.isConnectionError ||
            previous.isPasswordError != current.isPasswordError,
        listener: (context, state) {
          if (state.showDialog) {
            showDialog(
                context: context,
                useSafeArea: false,
                builder: (context) => DataDialog(data: state.result));
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Restore',
                          style: AppFonts.custom(
                              fontSize: 32, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Don\'t let other person see your screen',
                          style: AppFonts.custom(fontSize: 16)),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text('Use password to decrypt',
                      style: AppFonts.custom(
                          fontSize: 16, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.start),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(left: 16, right: 32, bottom: 12),
                  child: BlocBuilder<RestoreCubit, RestoreState>(
                      buildWhen: (previous, current) =>
                          previous.password != current.password ||
                          previous.showPassword != current.showPassword,
                      builder: (context, state) {
                        return TextField(
                          controller: passwordController,
                          obscureText: !state.showPassword,
                          decoration: InputDecoration(
                              hintText: 'Password',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  context
                                      .read<RestoreCubit>()
                                      .showPassword(!state.showPassword);
                                },
                                child: Image.asset(
                                    height: 25,
                                    'assets/images/${state.showPassword ? 'show_password' : 'hide_password'}.png'),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.lightGrey, width: 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: AppColors.lightGrey, width: 1))),
                          onChanged: (String value) {
                            context.read<RestoreCubit>().changePassword(value);
                          },
                        );
                      }),
                ),
                Container(
                  margin: const EdgeInsets.all(24),
                  width: double.maxFinite,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      onPressed: () {
                        context.read<RestoreCubit>().readNFCTag();
                      },
                      child: Text('Restore',
                          style: AppFonts.custom(
                              fontSize: 16, color: Colors.white))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
