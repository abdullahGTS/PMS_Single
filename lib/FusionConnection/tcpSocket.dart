// ignore_for_file: file_names

import 'dart:io';
import 'dart:async';

class TcpSocketConnection {
  late String _ipAddress;
  late int _portAddress;
  Socket? _server;
  bool _connected = false;
  bool _logPrintEnabled = false;

  TcpSocketConnection(String ip, int port) {
    _ipAddress = ip;
    _portAddress = port;
  }

  TcpSocketConnection.constructorWithPrint(String ip, int port, bool enable) {
    _ipAddress = ip;
    _portAddress = port;
    _logPrintEnabled = enable;
  }

  enableConsolePrint(bool enable) {
    _logPrintEnabled = enable;
  }

  connect(int timeOut, Function callback, {int attempts = 5}) async {
    int k = 1;
    while (k <= attempts) {
      try {
        _server = await Socket.connect(_ipAddress, _portAddress,
            // ignore: unnecessary_new
            timeout: new Duration(milliseconds: timeOut));
        break;
      } catch (ex) {
        _printData("$k attempt: Socket not connected (Timeout reached)");
        if (k == attempts) {
          return;
        }
      }
      k++;
    }
    _connected = true;
    _printData("Socket successfully connected");
    _server!.listen((List<int> event) async {
      callback(event);
    });
  }

  /// Stops the connection and close the socket
  void disconnect() {
    if (_server != null) {
      try {
        _server!.close();
        _printData("Socket disconnected successfully");
      } catch (exception) {
        // ignore: avoid_print
        print("ERROR$exception");
      }
    }
    _connected = false;
  }

  /// Checks if the socket is connected
  bool isConnected() {
    print('Abdullah-server-check-conn');
    return _server != null && _connected;
  }

  void sendMessage(List<int> message) async {
    if (_server != null && _connected) {
      _server!.add(message);
    } else {
      // ignore: avoid_print
      print(
          "Socket not initialized before sending message! Make sure you have already called the method 'connect()'");
    }
  }

  Future<bool> canConnect(int timeOut, {int attempts = 5}) async {
    int k = 1;
    while (k <= attempts) {
      try {
        _server = await Socket.connect(_ipAddress, _portAddress,
            // ignore: unnecessary_new
            timeout: new Duration(milliseconds: timeOut));
        // ignore: unnecessary_this
        this.disconnect();
        return true;
      } catch (exception) {
        _printData("$k attempt: Socket not connected (Timeout reached)");
        if (k == attempts) {
          // ignore: unnecessary_this
          this.disconnect();
          return false;
        }
      }
      k++;
    }
    // ignore: unnecessary_this
    this.disconnect();
    return false;
  }

  void _printData(String data) {
    if (_logPrintEnabled) {
      // ignore: avoid_print
      print(data);
    }
  }
}
