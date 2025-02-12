import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddressProvider extends ChangeNotifier {
  List<dynamic> _addresses = [];
  bool _isLoading = false;

  List<dynamic> get addresses => _addresses;
  bool get isLoading => _isLoading;

  Future<void> searchAddress(String query) async {
    if (query.isEmpty) return; // Prevent empty requests
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://api.2degrees.nz/sales/v3/qualification/addresses/search?address=$query');

    try {
      final response = await http.get(url);
      debugPrint('API Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        debugPrint('API Response: ${response.body}');

        final data = json.decode(response.body);
        _addresses = data['addresses'] ?? []; // Extract addresses list properly
      } else {
        debugPrint("no response");
        _addresses = [];
      }
    } catch (e) {
      debugPrint("Error: $e");
      _addresses = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
