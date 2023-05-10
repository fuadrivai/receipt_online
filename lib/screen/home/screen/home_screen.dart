import 'package:flutter/material.dart';
import 'package:receipt_online_shop/screen/daily_task/screen/daily_task_screen.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
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
  Expedition? expedition;
  @override
  void initState() {
    context.read<HomeBloc>().add(GetData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: Drawer(
          child: ListView(
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
        ],
      )),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (__, state) {
          if (state is HomeLoadingState) {
            return const LoadingScreen();
          }
          if (state is DataState) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: Padding(
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
                                        builder: (__) => DailyTaskScreen(
                                          dailyTaskId: e.id!,
                                          platform: e.expedition?.alias ?? "",
                                        ),
                                      ),
                                    ).then((value) {
                                      context.read<HomeBloc>().add(GetData());
                                    });
                                  },
                                  child: Card(
                                      child: ListTile(
                                    trailing: const Icon(
                                      Icons.fire_truck,
                                      color: Color.fromARGB(255, 96, 151, 245),
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
                        onPressed: () {
                          _formDialog(state);
                        },
                        child: const Text(
                          "+ Buat Tugas Harian",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          if (state is HomeErrorState) {
            return Center(
              child: Text(state.error.toString()),
            );
          }
          return Container();
        },
      ),
    );
  }

  Future _refresh() async {
    context.read<HomeBloc>().add(GetData());
  }

  _formDialog(DataState state) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                        DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            hint: Text(
                              'Select Item',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: (state.expeditions ?? [])
                                .map((item) => DropdownMenuItem<Expedition>(
                                      value: item,
                                      child: Text(
                                        item.name ?? "--",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            value: expedition,
                            onChanged: (Expedition? value) {
                              setState(() {
                                context
                                    .read<HomeBloc>()
                                    .add(OnChangeExpedition(value!));
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: TextFormDecoration.box("Total Paket"),
                          onChanged: (value) {
                            setState(() {
                              int val = (value == "") ? 0 : int.parse(value);
                              context.read<HomeBloc>().add(OnChangeTotal(val));
                            });
                          },
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
                      // if (_formKey.currentState!.validate()) {
                      //   context.read<HomeBloc>().add(OnSaveDailyTask());
                      // }
                    })
              ],
            );
          },
        );
      },
    );
  }
}
