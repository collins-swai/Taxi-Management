import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'presentation/blocs/auth_bloc.dart';
import 'presentation/blocs/car_bloc.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/car_repository.dart';
import 'domain/usecases/auth_usecases.dart';
import 'domain/usecases/car_usecases.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/register_page.dart';
import 'presentation/pages/car_listing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = 'https://d307-80-240-201-165.ngrok-free.app';

    final authRepository = AuthRepository(baseUrl);
    final authUseCases = AuthUseCases(authRepository);

    final carRepository = CarRepository(baseUrl);
    final carUseCases = CarUseCases(carRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authUseCases),
        ),
        BlocProvider(
          create: (context) {
            final authState = BlocProvider.of<AuthBloc>(context).state;
            final token = (authState is Authenticated) ? authState.token : '';
            return CarBloc(carUseCases)..add(FetchCars(token));
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Car Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/carList': (context) => CarListPage(),
        },
      ),
    );
  }
}
