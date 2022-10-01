import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/model/daily_task.dart';
import 'package:receipt_online_shop/screen/daily_task/bloc/daily_task_bloc.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';
import 'package:responsive_grid/responsive_grid.dart';

class DailyTaskScreen extends StatefulWidget {
  final int? dailyTaskId;
  const DailyTaskScreen({
    super.key,
    this.dailyTaskId,
  });

  @override
  State<DailyTaskScreen> createState() => _DailyTaskScreenState();
}

class _DailyTaskScreenState extends State<DailyTaskScreen> {
  final DailyTask _dailyTask = DailyTask();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Tugas Harian'),
        actions: [
          IconButton(
            icon: const Icon(Icons.scanner),
            onPressed: () {},
          )
        ],
      ),
      body: BlocBuilder<DailyTaskBloc, DailyTaskState>(
        builder: (__, state) {
          return state.isLoading
              ? LoadingScreen()
              : ListView(
                  children: [
                    ResponsiveGridRow(children: [
                      ResponsiveGridCol(
                          child: Card(
                        child: Text(_dailyTask.expedition?.name ?? 'Expedisi'),
                      ))
                    ])
                  ],
                );
        },
      ),
    );
  }
}
