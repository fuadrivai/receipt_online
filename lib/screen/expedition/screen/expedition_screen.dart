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
  final _formKey = GlobalKey<FormState>();

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
                    return Card(
                      child: ListTile(
                        leading: const Icon(
                          Icons.fire_truck,
                          color: Colors.blue,
                        ),
                        title: Text(expedition.name ?? "-"),
                        subtitle: Text(expedition.alias ?? "-"),
                        onTap: _formDialog,
                      ),
                    );
                  },
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
                  const Text('Form Expedisi'),
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
                      decoration: const InputDecoration(
                        labelText: 'Expedisi',
                        icon: Icon(Icons.fire_truck),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Alias',
                        icon: Icon(Icons.car_rental_outlined),
                      ),
                    ),
                    TextFormField(
                      minLines: 2,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Sumber ',
                        icon: Icon(Icons.storage),
                      ),
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
