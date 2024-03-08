import 'package:flutter/material.dart';

class ButtonEntry extends StatelessWidget {
  final String giris;
  const ButtonEntry({required this.giris});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        giris,
        style: TextStyle(
          color: Colors.brown,
          fontSize: 20,
          // decoration: TextDecoration.underline,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.brown,
            width: 2,
          ),
        ),
      ),
    );
  }
}

class CardEntry extends StatelessWidget {
  final IconData icon;
  final String text;

  const CardEntry({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 45,
      ),
      color: Colors.brown[500],
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
