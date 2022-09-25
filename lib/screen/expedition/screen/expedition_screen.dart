import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipt_online_shop/screen/expedition/bloc/expedition_bloc.dart';
import 'package:receipt_online_shop/screen/expedition/data/expedition.dart';
import 'package:receipt_online_shop/widget/loading_screen.dart';

class ExpeditionScreen extends StatefulWidget {
  const ExpeditionScreen({super.key});

  @override
  State<ExpeditionScreen> createState() => _ExpeditionScreenState();
}

class _ExpeditionScreenState extends State<ExpeditionScreen> {
  @override
  void initState() {
    context.read<ExpeditionBloc>().add(GetExpedition());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expedisi"),
      ),
      body: BlocBuilder<ExpeditionBloc, ExpeditionState>(
        builder: (context, state) {
          return state.isLoading
              ? const LoadingScreen()
              : ListView.builder(
                  itemCount: state.expeditions?.length ?? 0,
                  itemBuilder: (context, i) {
                    Expedition expedition =
                        state.expeditions?[i] ?? Expedition();
                    return Text(expedition.name ?? "");
                  },
                );
        },
      ),
    );
  }
}
