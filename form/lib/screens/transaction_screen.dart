import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form/bloc/transaction_bloc.dart';
import 'package:form/bloc/transaction_event.dart';
import 'package:form/bloc/transaction_state.dart';
import 'package:form/models/transaction.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TransactionScreen extends StatelessWidget {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: ListTile(
                title: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        // Xử lý sự kiện quay lại
                        Navigator.of(context).pop();
                      },
                    ),
                    const Text(
                      "Đóng",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                subtitle: const Text(
                  "Nhập giao dịch",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll<Color>(
                      Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.saveAndValidate() ?? false) {
                      final formValues = _formKey.currentState?.value;
                      final transaction = TransactionModel(
                        dateTime: formValues?['dateTime'],
                        quantity: double.parse(formValues?['quantity']),
                        pump: formValues?['pump'],
                        revenue: double.parse(formValues?['revenue']),
                        price: double.parse(formValues?['price']),
                      );
                      BlocProvider.of<TransactionBloc>(context).add(
                        UpdateTransactionEvent(transaction),
                      );
                    }
                  },
                  child: const Text(
                    "Cập nhật",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // AppBar(
            //   title: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           // Icon quay lại
            //           IconButton(
            //             icon: const Icon(Icons.arrow_back, color: Colors.black),
            //             onPressed: () {
            //               // Xử lý sự kiện quay lại
            //               Navigator.of(context).pop();
            //             },
            //           ),
            //           // Chữ "Đóng"
            //           const Text(
            //             "Đóng",
            //             style: TextStyle(
            //               color: Colors.black,
            //               fontSize: 16,
            //             ),
            //           ),
            //         ],
            //       ), // Tiêu đề
            //       const Expanded(
            //         child: Text(
            //           "Nhập giao dịch",
            //           style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 32,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           textAlign: TextAlign.center, // Căn giữa tiêu đề
            //         ),
            //       ),
            //     ],
            //   ),
            //   actions: [
            //     ElevatedButton(
            //       style: const ButtonStyle(
            //         backgroundColor: WidgetStatePropertyAll<Color>(
            //           Colors.blue,
            //         ),
            //       ),
            //       onPressed: () {
            //         if (_formKey.currentState?.saveAndValidate() ?? false) {
            //           final formValues = _formKey.currentState?.value;
            //           final transaction = TransactionModel(
            //             dateTime: formValues?['dateTime'],
            //             quantity: double.parse(formValues?['quantity']),
            //             pump: formValues?['pump'],
            //             revenue: double.parse(formValues?['revenue']),
            //             price: double.parse(formValues?['price']),
            //           );
            //           BlocProvider.of<TransactionBloc>(context).add(
            //             UpdateTransactionEvent(transaction),
            //           );
            //         }
            //       },
            //       child: const Text(
            //         "Cập nhật",
            //         style: TextStyle(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocListener<TransactionBloc, TransactionState>(
                listener: (context, state) {
                  if (state is TransactionSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is TransactionError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage)),
                    );
                  }
                },
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Dùng TextField để hiển thị thời gian đã chọn
                      FormBuilderField<DateTime>(
                        name: 'dateTime',
                        initialValue: DateTime.now(),
                        validator: FormBuilderValidators.required(),
                        builder: (FormFieldState<DateTime?> field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'Thời gian',
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today_sharp),
                                onPressed: () async {
                                  // Hiển thị DatePicker
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: field.value ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (selectedDate != null) {
                                    TimeOfDay? selectedTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          field.value ?? DateTime.now()),
                                    );

                                    if (selectedTime != null) {
                                      final selectedDateTime = DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        selectedTime.hour,
                                        selectedTime.minute,
                                      );
                                      // Cập nhật giá trị đã chọn
                                      field.didChange(selectedDateTime);
                                    }
                                  }
                                },
                              ),
                            ),
                            child: Text(
                              field.value != null
                                  ? "${field.value!.toLocal()}"
                                  : "Chưa chọn thời gian",
                              style: TextStyle(
                                fontSize: 16,
                                color:
                                    field.hasError ? Colors.red : Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: 'quantity',
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Số lượng',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                          FormBuilderValidators.min(0.01),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormBuilderDropdown(
                        name: 'pump',
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Trụ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        items: ['Trụ 1', 'Trụ 2', 'Trụ 3']
                            .map((pump) => DropdownMenuItem(
                                  value: pump,
                                  child: Text(pump),
                                ))
                            .toList(),
                        validator: FormBuilderValidators.required(),
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: 'revenue',
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Doanh thu',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: 'price',
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Đơn giá',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.numeric(),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
