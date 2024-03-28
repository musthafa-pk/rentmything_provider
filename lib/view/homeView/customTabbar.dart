import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  final List<Tab> tabs;
  final ValueChanged<int> onChanged;
  final int currentIndex;

  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.onChanged,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.tabs.length,
      itemBuilder: (context, index) {
        final tab = widget.tabs[index];
        final isSelected = index == widget.currentIndex;

        return GestureDetector(
          onTap: () {
            widget.onChanged(index);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tab.icon != null) ...[
                  Icon(
                    Icons.ice_skating,
                    color: isSelected ? Colors.white : Colors.white60,
                  ),
                  SizedBox(width: 8),
                ],
                Text(
                  tab.text ?? '',
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
