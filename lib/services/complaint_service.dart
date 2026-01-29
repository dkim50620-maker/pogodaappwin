import 'dart:convert';
import 'package:http/http.dart' as http;

class ComplaintService {
  final String _endpoint = 'https://formspree.io/f/xvzrabbq';

  Future<bool> sendComplaint({
    required String email,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'message': message,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
