import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class QualificationProvider extends ChangeNotifier {
  // Constants for configuration data
  static const int addressResultsPagination = 5;
  static const bool allowVoiceNoFeatures = false;
  static const List<String> availableBillFrequencies = ["Monthly"];
  static const List<String> businessGroups = ["Slingshot", "2degrees", "Orcon"];
  static const int minimumContractLength = 12;
  static const String preferredCoreProductBroadbandCategory = "UFB1000/500";
  static const String salesChannel = "OnlineSignup";

  bool _isFibre1000Available = false;
  bool _isLoading = false;
  String _address = "";

  bool get isFibre1000Available => _isFibre1000Available;
  bool get isLoading => _isLoading;
  String get address => _address;

  Future<void> checkQualification(String locationId) async {
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
      'https://api.2degrees.nz/sales/v3/qualification/qualify'
          '?businessGroup=2degrees&salesChannel=$salesChannel&locationId=$locationId',
    );

    debugPrint('Fetching qualification for locationId: $locationId');
    debugPrint('Request URL: $url');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        debugPrint('Decoded JSON: $data');

        // Extract address if available
        if (data.containsKey('address') && data['address'] is Map<String, dynamic>) {
          _address = data['address']['addressText'] ?? 'Address not available';
        } else {
          _address = 'Address not available';
        }

        // Check if coreServices exists and is a list
        if (data.containsKey('coreServices') &&
            data['coreServices'] is List &&
            (data['coreServices'] as List).isNotEmpty) {

          List<dynamic> coreServices = data['coreServices'];
          debugPrint('coreServices: $coreServices');

          // Check if any service contains "fibre 1000"
          _isFibre1000Available = coreServices.any((service) =>
          service is Map<String, dynamic> &&
              service.containsKey('coreProducts') &&
              service['coreProducts'] is List &&
              (service['coreProducts'] as List).any((product) =>
              product is Map<String, dynamic> &&
                  product.containsKey('coreProductBroadbandCategory') &&
                  product['coreProductBroadbandCategory']
                      .toString()
                      .toLowerCase()
                      .contains('ufb1000')
              ));
         // debugPrint('coreProductBroadbandCategory: ${coreServices['coreProducts'].}');
          debugPrint('Fibre 1000 Available: $_isFibre1000Available');
        } else {
          // Handle case when coreServices is empty or not found
          debugPrint('coreServices key is empty or invalid format or not found');
          debugPrint('coreServices: ${data['coreServices']}');
          _isFibre1000Available = false;
        }
      } else {
        debugPrint('Unexpected response status: ${response.statusCode}');
        _isFibre1000Available = false;
        _address = "Error fetching";
      }
    } catch (e) {
      debugPrint('Error fetching qualification data: $e');
      _isFibre1000Available = false;
      _address = "Error fetching";
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearAddress() {
    _address = "";
    notifyListeners();
  }
}
