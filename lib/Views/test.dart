import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

bool goingDown = false;
FloatingActionButton goUp;
ScrollController scrollController;

class _TestState extends State<Test> {
  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          goingDown = false;
        });
      } else {
        setState(() {
          goingDown = true;
        });
      }
    });
    goUp = FloatingActionButton(
      child: Icon(Icons.arrow_upward),
      onPressed: () {
        scrollController.animateTo(
          0.0,
          curve: Curves.ease,
          duration: Duration(milliseconds: 500),
        );
      },
    );
    super.initState();
  }

  FloatingActionButton renderGoUp() {
    if (goingDown && scrollController.position.pixels > 0.0) {
      return goUp;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final List<ListItem> items = List<ListItem>.generate(
      10000,
      (i) => i % 6 == 0
          ? HeadingItem("Heading $i")
          : MessageItem("Sender $i", "Message body $i"),
    );
    final title = 'Mixed List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        floatingActionButton: renderGoUp(),
        body: Scrollbar(
          child: ListView.builder(
            controller: scrollController,
            // Let the ListView know how many items it needs to build.
            itemCount: items.length,
            // Provide a builder function. This is where the magic happens.
            // Convert each item into a widget based on the type of item it is.
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(
                title: item.buildTitle(context),
                subtitle: item.buildSubtitle(context),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget buildSubtitle(BuildContext context) => null;
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  Widget buildTitle(BuildContext context) => Text(sender);

  Widget buildSubtitle(BuildContext context) => Text(body);
}
