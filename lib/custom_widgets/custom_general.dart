part of custom_widgets;

class ContentColumn extends StatelessWidget {
  ContentColumn({@required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
          children: children
              .map((child) => Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: child,
                  ))
              .toList()),
    );
  }
}
