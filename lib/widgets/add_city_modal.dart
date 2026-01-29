import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AddCityModal extends StatefulWidget {
  final Function(String city, String temp) onAdd;

  const AddCityModal({super.key, required this.onAdd});

  @override
  State<AddCityModal> createState() => _AddCityModalState();
}

class _AddCityModalState extends State<AddCityModal> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add City', style: TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter city name',
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  widget.onAdd(_controller.text, '20°'); // локальная температура
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          )
        ],
      ),
    );
  }
}
