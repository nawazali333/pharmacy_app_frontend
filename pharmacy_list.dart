import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'medicine_list.dart';

class PharmacyListScreen extends StatefulWidget {
  @override
  _PharmacyListScreenState createState() => _PharmacyListScreenState();
}

class _PharmacyListScreenState extends State<PharmacyListScreen> {
  final storage = FlutterSecureStorage();
  List pharmacies = [];

  Future<void> _fetchPharmacies() async {
    final token = await storage.read(key: 'token');
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/pharmacies'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        pharmacies = jsonDecode(response.body);
      });
    } else {
      // Handle fetch error
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPharmacies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pharmacies'),
      ),
      body: ListView.builder(
        itemCount: pharmacies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pharmacies[index]['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicineListScreen(pharmacyId: pharmacies[index]['_id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
