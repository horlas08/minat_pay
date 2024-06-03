import 'package:flutter/material.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    bool status = true;
    return Row(
      children: [
        const SizedBox(
          height: 60,
          width: 60,
          child: CircleAvatar(
            backgroundImage: AssetImage("assets/images/avatar.png"),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good Morning"),
            Text(
              "SMD TECH",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "Which Bill Would You Like To Pay?",
              style: TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(Icons.notifications),
            SizedBox(
                width: 50,
                height: 10,
                child: Switch(
                  value: status,
                  onChanged: (bool v) {
                    status = v;
                  },
                )),
          ],
        )
      ],
    );
  }
}
