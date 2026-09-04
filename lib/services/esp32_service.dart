import 'dart:convert';
import 'package:http/http.dart' as http;

class Esp32Service {
  final String esp32Ip;

  Esp32Service(this.esp32Ip);

  Future<bool> checkConnection() async {
    try {
      final response =
      await http.get(Uri.parse("http://$esp32Ip/ping"));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchSensorData() async {
    final response =
    await http.get(Uri.parse("http://$esp32Ip/data"));
    return jsonDecode(response.body);
  }
}
