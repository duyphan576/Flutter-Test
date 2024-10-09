import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../blocs/report_bloc.dart';
import '../blocs/report_event.dart';
import '../blocs/report_state.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tính tổng Thành tiền"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx'],
                );

                if (result != null) {
                  final file = File(result.files.single.path!);
                  context.read<ReportBloc>().add(UploadReportFileEvent(file));
                }
              },
              child: const Text("Upload file báo cáo"),
            ),
            TextField(
              controller: startTimeController,
              decoration:
                  const InputDecoration(labelText: "Giờ bắt đầu (hh:mm)"),
            ),
            TextField(
              controller: endTimeController,
              decoration:
                  const InputDecoration(labelText: "Giờ kết thúc (hh:mm)"),
            ),
            ElevatedButton(
              onPressed: () {
                final startTime = startTimeController.text;
                final endTime = endTimeController.text;
                context
                    .read<ReportBloc>()
                    .add(CalculateTotalEvent(startTime, endTime));
              },
              child: const Text("Tính tổng"),
            ),
            BlocBuilder<ReportBloc, ReportState>(
              builder: (context, state) {
                if (state is ReportLoading) {
                  return const CircularProgressIndicator();
                } else if (state is ReportCalculated) {
                  return Text("Tổng Thành tiền: ${state.totalAmount}");
                } else if (state is ReportError) {
                  print(state.message);
                  return Text("Đã có lỗi xảy ra: ${state.message}");
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
