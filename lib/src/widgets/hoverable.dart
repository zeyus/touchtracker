import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Hoverable extends StatefulWidget {
  final Widget child;
  final Function? onHover;
  final Function? onExit;

  const Hoverable({Key? key, required this.child, this.onHover, this.onExit})
      : assert(onHover != null || onExit != null),
        super(key: key);

  @override
  _HoverableState createState() => _HoverableState();
}

// hoverable widget state
class _HoverableState extends State<Hoverable> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEnterEvent details) {
        setState(() {
          _hovering = true;
        });
        widget.onHover!();
      },
      onExit: (PointerExitEvent details) {
        setState(() {
          _hovering = false;
        });
        widget.onExit!();
      },
      child: widget.child,
    );
  }
}
