import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String? kota_asal;
  final String? kota_tujuan;
  final String? berat;
  final String? kurir;

  const DetailPage({
    super.key,
    this.kota_asal,
    this.kota_tujuan,
    this.berat,
    this.kurir,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List listData = [];
  final String strKey = "aff1002c5b65baf69b177eeb09f64a30";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future getData() async {
    try {
      var response = await http.post(
        Uri.parse("https://api.rajaongkir.com/starter/cost"),
        headers: {
          "key": strKey,
          "content-type": "application/x-www-form-urlencoded",
        },
        body: {
          "origin": widget.kota_asal ?? '',
          "destination": widget.kota_tujuan ?? '',
          "weight": widget.berat ?? '0',
          "courier": widget.kurir ?? '',
        },
      );

      var data = jsonDecode(response.body);
      var results = data['rajaongkir']?['results'];

      setState(() {
        listData = results != null && results.isNotEmpty
            ? results[0]['costs']
            : [];
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Ongkos Kirim ${widget.kurir?.toUpperCase() ?? ""}"),
      ),
      body: listData.isEmpty
          ? const Center(child: Text("No data found"))
          : ListView.builder(
              itemCount: listData.length,
              itemBuilder: (_, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.white,
                  child: ListTile(
                    title: Text("${listData[index]['service']}"),
                    subtitle: Text("${listData[index]['description']}"),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          "Rp ${listData[index]['cost'][0]['value']}",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text("${listData[index]['cost'][0]['etd']} Days"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
