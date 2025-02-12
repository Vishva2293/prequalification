import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:prequalification/screens/qualification_screen.dart';
import 'package:provider/provider.dart';
import '../providers/address_provider.dart';
import '../providers/qualification_provider.dart';

class HomeContentScreen extends StatefulWidget {
  @override
  _HomeContentScreenState createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<HomeContentScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Qualification', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Search Address',
                hintText: 'Type an address...',
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                    _searchController.clear();
                    addressProvider.addresses.clear();
                  });
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onChanged: (text) {
                if (text.length > 2) {
                  addressProvider.searchAddress(text);
                }
              },
            ),
            SizedBox(height: 20),
            addressProvider.isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: addressProvider.addresses.isEmpty
                  ? Center(
                child: Text(
                  "No addresses found",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: addressProvider.addresses.length,
                itemBuilder: (context, index) {
                  var address = addressProvider.addresses[index] ?? {};
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      title: Text(
                        address['addressText'] ?? 'Unknown Address',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${address['suburb']}, ${address['city']} ${address['postCode']}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QualificationScreen(locationId: address['locationId'].toString().toLowerCase()),
                          ),
                        );
                        // Reset address after returning
                        Provider.of<QualificationProvider>(context, listen: false).clearAddress();
                      },
                    ),
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
