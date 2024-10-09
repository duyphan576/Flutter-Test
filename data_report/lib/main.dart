import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/report_bloc.dart';
import 'repositories/report_repository.dart';
import 'screens/report_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => ReportBloc(reportRepository: ReportRepository()),
        child: const ReportPage(),
      ),
    );
  }
}
