import 'package:flutter/material.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/screen/home/bloc/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';

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
              : ListView.builder(
                  itemCount: state.dailyTasks?.length ?? 0,
                  itemBuilder: (context, i) {
                    DailyTask dailyTask = state.dailyTasks?[i] ?? DailyTask();
                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.fire_truck,
                          color: Colors.blue,
                        ),
                        title: Text(dailyTask.expedition?.name ?? "-"),
                        subtitle: Text(
                            "${dailyTask.receipts?.length ?? 0} / ${dailyTask.totalPackage}"),
                      ),
                    );
                  },
                );
          ;
        },
      ),
    );
  }
}
