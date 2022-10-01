import 'package:flutter/material.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/screen/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:responsive_grid/responsive_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                                  child: Card(
                                      child: ListTile(
                                    onTap: () {
                                      print(e);
                                    },
                                    trailing: const Icon(
                                      Icons.fire_truck,
                                      color: Color.fromARGB(255, 96, 151, 245),
                                    ),
                                    title: Center(
                                      child: Text(
                                        "${e.totalPackage} / ${e.receipts?.length ?? 0}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    subtitle: Center(
                                        child: Text(
                                      '${e.expedition?.name}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700),
                                    )),
                                  )),
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
                          onPressed: () {},
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
}
