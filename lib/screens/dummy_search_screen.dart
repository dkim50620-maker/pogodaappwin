import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/app_colors.dart';

class DummySearchScreen extends StatefulWidget {
  const DummySearchScreen({super.key});

  @override
  State<DummySearchScreen> createState() => _DummySearchScreenState();
}

class _DummySearchScreenState extends State<DummySearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Map<String, dynamic>? user;
  String? error;
  bool loading = false;

  Future<void> fetchUser(int id) async {
    setState(() {
      loading = true;
      error = null;
      user = null;
    });

    final response = await http.get(
      Uri.parse('https://dummyjson.com/users/$id'),
    );

    if (response.statusCode == 200) {
      setState(() {
        user = jsonDecode(response.body);
        loading = false;
      });
    } else {
      setState(() {
        error = 'User not found';
        loading = false;
      });
    }
  }

  void _search() {
    final id = int.tryParse(_controller.text);
    if (id != null) {
      fetchUser(id);
    } else {
      setState(() {
        error = 'Enter a valid ID';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('DummyJSON Search'),
        backgroundColor: AppColors.background,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter user ID (e.g. 1)',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: AppColors.card,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _search,
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (loading) const CircularProgressIndicator(),

            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.redAccent)),

            if (user != null)
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user!['firstName']} ${user!['lastName']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text('ID: ${user!['id']}',
                        style: const TextStyle(color: Colors.white70)),
                    Text('Email: ${user!['email']}',
                        style: const TextStyle(color: Colors.white70)),
                    Text('Phone: ${user!['phone']}',
                        style: const TextStyle(color: Colors.white70)),
                    Text('City: ${user!['address']['city']}',
                        style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
