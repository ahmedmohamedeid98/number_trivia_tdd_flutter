import 'package:flutter/material.dart';

class ElevButton extends StatelessWidget {
  final Function onPressed;
  final String label;
  final Color backgroundColor;

  const ElevButton({
    Key key,
    @required this.onPressed,
    @required this.label,
    this.backgroundColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (states) => backgroundColor ?? Theme.of(context).accentColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          label,
          style: TextStyle(fontSize: 20),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
