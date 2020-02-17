part of custom_widgets;

class CustomRowData {
  CustomRowData(this.left, this.right);
  final Widget left;
  final String right;
}

class CustomShade {
  static const shade0 = [100, 50];
  static const shade1 = [200, 100];
  static const shade2 = [300, 200];
  static const shade3 = [400, 300];
  static const shade4 = [500, 400];
}

class CustomTable extends StatelessWidget {
  CustomTable(
      {@required this.title,
      @required this.titleColor,
      @required this.borderColor,
      @required this.children});
  final String title;
  final Color titleColor;
  final Color borderColor;
  final List<TableRow> children;

  CustomTable.withColor({
    @required this.title,
    @required List<CustomRowData> children,
    MaterialColor color = Colors.grey,
    var shade = CustomShade.shade1
  })  : titleColor = color[shade[0]],
        borderColor = color[shade[0]],
        children = children
            .asMap()
            .map(
              (ind, child) => MapEntry(
                ind,
                customRow(
                  left: child.left,
                  right: child.right,
                  color: color[shade[1]],
                  last: (ind == children.length-1)
                ),
              ),
            )
            .values
            .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: titleColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          border: TableBorder(
            horizontalInside: BorderSide(color: borderColor),
          ),
          children: children,
        ),
      ],
    );
  }
}

TableRow customRow(
    {@required Text left,
    @required String right,
    @required Color color,
    bool last = false}) {
  return TableRow(
    decoration: BoxDecoration(
        color: color,
        borderRadius: last
            ? BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              )
            : null),
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: left,
      ),
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        child: Text(
          right,
          style: TextStyle(fontSize: 20),
        ),
      ),
    ],
  );
}
