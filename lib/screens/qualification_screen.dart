import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/qualification_provider.dart';

class QualificationScreen extends StatefulWidget {
  final String locationId;

  QualificationScreen({required this.locationId});

  @override
  _QualificationScreenState createState() => _QualificationScreenState();
}

class _QualificationScreenState extends State<QualificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QualificationProvider>(context, listen: false)
          .checkQualification(widget.locationId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final qualificationProvider = Provider.of<QualificationProvider>(context);
    var address = qualificationProvider.address;

    return Scaffold(
      appBar: AppBar(
        title: Text('Qualification Result', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location Id :', style: TextStyle(color: Colors.blue,fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text(widget.locationId, style: TextStyle(fontSize: 15)),
            SizedBox(height: 20),
            Text('Address :', style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight:FontWeight.bold)),
            SizedBox(height: 6),
            Text(address.toString() ?? "", style: TextStyle(fontSize: 15)),
            SizedBox(height: 20),
            Text('Is 1000 fiber available ? :', style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight:FontWeight.bold)),
            SizedBox(height: 16),
            qualificationProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : Text(
              qualificationProvider.isFibre1000Available
                  ? "Fibre 1000 is Available ✅"
                  : "Fibre 1000 is NOT Available ❌",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

}
