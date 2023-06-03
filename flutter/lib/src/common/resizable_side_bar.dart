import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ResizableSideBar extends HookWidget {
  final List<Widget> sideBarChildren;
  final List<Widget> mainViewChildren;

  const ResizableSideBar({
    Key? key,
    required this.sideBarChildren,
    required this.mainViewChildren,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sidebarWidth = useState<double>(250);

    List<Widget> buildSideBarChildren() {
      return sideBarChildren
          .map(
            (child) => SizedBox(
              width: sidebarWidth.value,
              child: SizedBox(
                width: sidebarWidth.value,
                child: child,
              ),
            ),
          )
          .toList();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: Column(
            children: buildSideBarChildren(),
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.resizeColumn,
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: (details) {
                sidebarWidth.value = sidebarWidth.value + details.delta.dx;
              },
              child: VerticalDivider(
                width: 20,
                color: Theme.of(context).dividerColor,
              )),
        ),
        ...mainViewChildren
      ],
    );
  }
}
