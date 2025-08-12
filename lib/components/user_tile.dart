import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTile({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(left: 25, right: 25, top: 10),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [Icon(Icons.person), const SizedBox(width: 10), Text(text)],
        ),
      ),
    );
  }
}
