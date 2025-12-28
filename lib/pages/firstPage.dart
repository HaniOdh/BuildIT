import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  AppBar _appBar(){
    return AppBar(
        title: Text('History App',
        style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown);
  }

  ElevatedButton _elevatedButtonWithIsolates(){
    return ElevatedButton(
      onPressed:(){},
      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
      child: Text('With Isolates', style: TextStyle(color: Colors.white),
      ),
    );
  }

  ElevatedButton _elevatedButtonNoIsolates(){
    return ElevatedButton(
      onPressed:(){},
      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
      child: Text('No Isolates', style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _elevatedButtonNoIsolates(),
            const SizedBox(width: 10),
            _elevatedButtonWithIsolates(),
          ],
        ),
      )
    );
  }
}
