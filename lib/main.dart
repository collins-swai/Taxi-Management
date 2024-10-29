import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:taxi_system/data/models/car_model.dart';
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
  late PusherClient pusher;

  @override
  void initState() {
    super.initState();

    pusher = PusherClient(
      'b3baa847b08be8b76de1',
      PusherOptions(cluster: 'ap2'),
      enableLogging: true,
    );

    pusher.connect();
    _subscribeToChannels();
  }

  void _subscribeToChannels() {
    var channel = pusher.subscribe('car-channel');

    channel.bind('CarAdded', (PusherEvent? event) {
      if (event != null && event.data != null) {
        final data = json.decode(event.data!) as Map<String, dynamic>;
        final car = Car.fromJson(data);
        BlocProvider.of<CarBloc>(context).handleRealTimeCarAdded(car);
      }
    });

    channel.bind('CarUpdated', (PusherEvent? event) {
      if (event != null && event.data != null) {
        final data = json.decode(event.data!) as Map<String, dynamic>;
        final car = Car.fromJson(data);
        BlocProvider.of<CarBloc>(context).handleRealTimeCarUpdated(car);
      }
    });

    channel.bind('CarDeleted', (PusherEvent? event) {
      if (event != null && event.data != null) {
        final data = json.decode(event.data!) as Map<String, dynamic>;
        final carId = data['id'] as String;
        BlocProvider.of<CarBloc>(context).handleRealTimeCarDeleted(carId);
      }
    });
  }


  @override
  void dispose() {
    pusher.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String baseUrl = 'https://131a-80-240-201-164.ngrok-free.app';

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
