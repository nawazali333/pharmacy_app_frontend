import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MedicineListScreen extends StatefulWidget {
  final String pharmacyId;

  MedicineListScreen({required this.pharmacyId});

  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final storage = FlutterSecureStorage();
  List medicines = [];

  Future<void> _fetchMedicines() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/medicines/${widget.pharmacyId}'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        medicines = jsonDecode(response.body);
      });
    } else {
      // Handle fetch error
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicines'),
      ),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(medicines[index]['name']),
            subtitle: Text('Price: \$${medicines[index]['price']}'),
          );
        },
      ),
    );
  }
}
