import 'package:flutter/material.dart';
import 'package:receipt_online_shop/model/receipt.dart';

class SearchTaskDelegate extends SearchDelegate {
  final List<Receipt> listReceipt;
  SearchTaskDelegate(this.listReceipt);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Receipt> matchQuery = [];
    for (var receipt in listReceipt) {
      if ((receipt.number ?? "").toUpperCase().contains(query.toUpperCase())) {
        if (receipt.number != null) {
          matchQuery.add(receipt);
        }
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.number ?? ""),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Receipt> matchQuery = [];
    for (var receipt in listReceipt) {
      if ((receipt.number ?? "").toUpperCase().contains(query.toUpperCase())) {
        if (receipt.number != null) {
          matchQuery.add(receipt);
        }
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.number ?? ""),
        );
      },
    );
  }
}
