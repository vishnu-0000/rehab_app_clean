import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class HardwareHttpServer {
  HttpServer? _server;
  Function(Map<String, dynamic>)? onDataReceived;

  Future<void> startServer() async {
    final handler = Pipeline().addHandler((Request request) async {
      if (request.method == 'POST') {
        final body = await request.readAsString();
        final data = jsonDecode(body);

        if (onDataReceived != null) {
          onDataReceived!(data);
        }

        return Response.ok('OK');
      }
      return Response.notFound('Not Found');
    });

    _server = await shelf_io.serve(handler, '0.0.0.0', 8080);
    print("Hardware server running on port 8080");
  }

  void stopServer() {
    _server?.close();
  }
}
