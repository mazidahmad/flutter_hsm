import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_hsm/flutter_hsm.dart';

final _messangerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _hsmPackage = FlutterHardwareSecureModule();
  final String tag = "keychain-coinbit.privateKey";
  final String tagBiometric = "keychain-coinbit.privateKeyPresence";
  bool _isRequiresBiometric = false;
  String publicKey = "";

  TextEditingController input = TextEditingController();

  Uint8List encrypted = Uint8List(0);
  Uint8List encryptedWithPublicKey = Uint8List(0);
  String decrypted = "";

  @override
  void initState() {
    super.initState();
  }

  void encrypt(String message) {
    _hsmPackage.encrypt(message: message, accessControl: AccessControlHsm(
      options: _isRequiresBiometric? [AccessControlOption.userPresence, AccessControlOption.privateKeyUsage] : [AccessControlOption.privateKeyUsage],
      authRequired: _isRequiresBiometric,
      tag: _isRequiresBiometric ? tagBiometric : tag,)).then((result) =>
        setState(() {
            encrypted = result ?? Uint8List(0);
        }));
  }

  void decrypt(Uint8List message) {
    _hsmPackage.decrypt(
       message: message, accessControl: AccessControlHsm(
      options: _isRequiresBiometric? [AccessControlOption.userPresence, AccessControlOption.privateKeyUsage] : [AccessControlOption.privateKeyUsage],
       authRequired: _isRequiresBiometric,
      tag: _isRequiresBiometric ? tagBiometric : tag,))
        .then((result) =>
        setState(() {
            decrypted = result ?? "";
        }));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            TextField(
              controller: input,
            ),
            Row(
              children: [
                const Text("Biometric"),
                const SizedBox(width: 10,),
                Switch(value: _isRequiresBiometric, onChanged: (value) {
                  setState(() {
                    _isRequiresBiometric = value;
                    encrypted = Uint8List(0);
                    decrypted = "";
                  });
                }),
              ],
            ),
            TextButton(onPressed: () {
              encrypt(input.text);
              // input.clear();
            }, child: Text("encrypt!")),
            Text(
                encrypted.toString()
            ),
            TextButton(onPressed: () {
              decrypt(encrypted);
            }, child: Text("decrypt!")),
            Text(
                decrypted
            ),
          ],
        ),
      ),
    );
  }
}
