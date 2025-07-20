import 'package:arabizi_transliterator/arabizi_transliterator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arabizi Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _fullTransliteration = '';
  String _partialTransliteration = '';
  List<String> _suggestions = [];
  final ArabiziTransliterator _transliterator = ArabiziTransliterator();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _fullTransliteration = _transliterator.transliterateFull(_controller.text.trim());
        _partialTransliteration = _transliterator.transliteratePartial(_controller.text.trim());
        _suggestions = _transliterator.getSuggestions(_controller.text.trim());
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arabizi Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter Arabizi text',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Full Transliteration:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _fullTransliteration,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),
            const Text(
              'Partial Transliteration:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _partialTransliteration,
              style: const TextStyle(fontSize: 24),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 20),
            const Text(
              'Suggestions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return Text(
                    _suggestions[index],
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.right,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
