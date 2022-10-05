import 'package:crypto_platz/src/features/home/view/home_controller.dart';
import 'package:crypto_platz/src/features/restore/view/restore_controller.dart';
import 'package:crypto_platz/src/features/save/view/save_controller.dart';
import 'package:crypto_platz/src/features/tabs/bloc/tabs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabsController extends StatelessWidget {
  const TabsController({Key? key}) : super(key: key);

  static const String routeName = '/tabs';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TabsCubit>(
      create: (context) => TabsCubit(),
      child: const _TabsView(),
    );
  }
}

class _TabsView extends StatelessWidget {
  const _TabsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabsCubit, int>(
      builder: (context, index) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: IndexedStack(
            index: index,
            children: const [
              HomeController(),
              SaveController(),
              RestoreController()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            onTap: (int newTab) {
              context.read<TabsCubit>().changeTab(newTab);
            },
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                  label: '', icon: Image.asset('assets/images/home.png')),
              BottomNavigationBarItem(
                  label: '', icon: Image.asset('assets/images/lock.png')),
              BottomNavigationBarItem(
                  label: '', icon: Image.asset('assets/images/unlock.png'))
            ],
          ),
        );
      },
    );
  }
}
