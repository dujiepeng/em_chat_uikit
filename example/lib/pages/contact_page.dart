import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class TestModel with ChatUIKitListItemModel {
  TestModel(this.name);
  final String name;
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return ContactView(
      listViewBeforeBuilder: (context, model) {
        return Container(
          color: Colors.red,
          child: Text((model as TestModel).name),
        );
      },
      listViewBeforeList: [TestModel('aaa'), TestModel('bbb')],
    );
  }
}
