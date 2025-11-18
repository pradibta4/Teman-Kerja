import 'package:coworkers/config/app_color.dart';
import 'package:coworkers/config/appwrite.dart';
import 'package:coworkers/config/enums.dart';
import 'package:coworkers/models/worker_model.dart';
import 'package:coworkers/pages/booking_page.dart';
import 'package:coworkers/pages/checkout_page.dart';
import 'package:coworkers/pages/dashboard.dart';
import 'package:coworkers/pages/get_started_page.dart';
import 'package:coworkers/pages/list_worker_page.dart';
import 'package:coworkers/pages/sign_in_page.dart';
import 'package:coworkers/pages/sign_up_page.dart';
import 'package:coworkers/pages/success_booking_page.dart';

import 'package:coworkers/pages/worker_profile_page.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/session.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Appwrite.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: AppColor.text,
          displayColor: AppColor.text,
        ),
        primaryColor: AppColor.primary,
        colorScheme: const ColorScheme.light(primary: AppColor.primary),
        filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size.fromHeight(52)),
            textStyle: WidgetStatePropertyAll(
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      initialRoute: AppRoute.dashboard.name,
      routes: {
        AppRoute.getStarted.name: (context) => const GetStartedPage(),
        AppRoute.signUp.name: (context) => const SignUpPage(),
        AppRoute.signIn.name: (context) => const SignInPage(),
        AppRoute.dashboard.name: (context) {
          return FutureBuilder(
            future: AppSession.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return DView.loadingCircle();
              }
              if (snapshot.data == null) {
                return const GetStartedPage();
              }
              return const Dashboard();
            },
          );
        },
        AppRoute.listWorker.name: (context) {
          String category =
              ModalRoute.of(context)!.settings.arguments as String;
          return ListWorkerPage(category: category);
        },
        AppRoute.workerProfile.name: (context) {
          WorkerModel worker =
              ModalRoute.of(context)!.settings.arguments as WorkerModel;
          return WorkerProfilePage(worker: worker);
        },
        AppRoute.booking.name: (context) {
          WorkerModel worker =
              ModalRoute.of(context)!.settings.arguments as WorkerModel;
          return BookingPage(worker: worker);
        },
        AppRoute.checkout.name: (context) => const CheckoutPage(),
        AppRoute.successBooking.name: (context) => const SuccessBookingPage(),
      },
    );
  }
}
