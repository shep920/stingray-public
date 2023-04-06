import 'package:flutter/material.dart';

class AdminNumberKeypad extends StatefulWidget {
  const AdminNumberKeypad({Key? key}) : super(key: key);

  @override
  _AdminNumberKeypadState createState() => _AdminNumberKeypadState();
}

class _AdminNumberKeypadState extends State<AdminNumberKeypad> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _textEditingController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter numbers',
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('1'),
            _buildNumberButton('2'),
            _buildNumberButton('3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('4'),
            _buildNumberButton('5'),
            _buildNumberButton('6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNumberButton('7'),
            _buildNumberButton('8'),
            _buildNumberButton('9'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(),
            _buildNumberButton('0'),
            IconButton(
              icon: const Icon(Icons.backspace),
              onPressed: () {
                if (_textEditingController.text.isNotEmpty) {
                  _textEditingController.text = _textEditingController.text
                      .substring(0, _textEditingController.text.length - 1);
                }
              },
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            if (_textEditingController.text == '115117') {
              Navigator.of(context).pop(true);
            } else {
              _textEditingController.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Incorrect number entered'),
                ),
              );
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildNumberButton(String text) {
    return ElevatedButton(
      onPressed: () {
        _textEditingController.text += text;
      },
      child: Text(text),
    );
  }
}

class Show {
  static Future<bool?> showNumberKeypad(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) {
        return AdminNumberKeypad();
      },
    );
  }
}
