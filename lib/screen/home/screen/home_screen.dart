import 'package:flutter/material.dart';
import 'package:receipt_online_shop/screen/daily_task/screen/daily_task_screen.dart';
import 'package:receipt_online_shop/screen/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:receipt_online_shop/widget/text_form_decoration.dart';
import 'package:responsive_grid/responsive_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    context.read<HomeBloc>().add(GetCurrentDailyTask());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (__, state) {
          return state.isLoading
              ? const LoadingScreen()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListView(
                    children: [
                      (state.dailyTasks ?? []).isNotEmpty
                          ? ResponsiveGridRow(
                              children: (state.dailyTasks ?? []).map((e) {
                                return ResponsiveGridCol(
                                  xs: 6,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (__) =>
                                              DailyTaskScreen(e.id!),
                                        ),
                                      );
                                    },
                                    child: Card(
                                        child: ListTile(
                                      trailing: const Icon(
                                        Icons.fire_truck,
                                        color:
                                            Color.fromARGB(255, 96, 151, 245),
                                      ),
                                      subtitle: Center(
                                        child: Text(
                                          "${e.receipts?.length ?? 0}/${e.totalPackage}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      title: Center(
                                          child: Text(
                                        '${e.expedition?.name}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      )),
                                    )),
                                  ),
                                );
                              }).toList(),
                            )
                          : const Card(
                              child: Center(
                                  child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Text('Tidak Ada Tugas Harian'),
                              )),
                            ),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 63, 157, 235),
                          ),
                          onPressed: _formDialog,
                          child: const Text(
                            "+ Buat Tugas Harian",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }

  _formDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Form Tugas Harian'),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close),
                  )
                ],
              ),
              const Divider(color: Colors.grey)
            ],
          ),
          content: Stack(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      readOnly: true,
                      decoration: TextFormDecoration.dateBox("Tanggal"),
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1990),
                          lastDate: DateTime(3000),
                        ).then((value) {
                          print(value);
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: TextFormDecoration.box("Expedisi"),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: TextFormDecoration.box("Total Paket"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                child: const Text("Submit"),
                onPressed: () {
                  // your code
                })
          ],
        );
      },
    );
  }
}
