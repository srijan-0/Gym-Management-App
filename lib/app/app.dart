import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login/features/category/presentation/bloc/category_bloc.dart';
import 'package:login/features/splash/presentation/view/onboardingscreen_view.dart';

import '../app/di/di.dart';
import '../features/auth/presentation/view_model/login/login_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => getIt<LoginBloc>(),
        ),
        BlocProvider<CategoryBloc>(
          // ✅ Add CategoryBloc
          create: (context) => getIt<CategoryBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Customer Management',
        home: const OnboardingScreenView(),
      ),
    );
  }
}
