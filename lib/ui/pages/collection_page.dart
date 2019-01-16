import 'package:alice/common/component_index.dart';
import 'package:flutter/material.dart';

class CollectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(IntlUtil.getString(context, Ids.titleCollection)),
        centerTitle: true,
      ),
      body: new ProgressView(),
    );
  }
}
