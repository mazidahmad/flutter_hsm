import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter_hsm/flutter_hsm.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final String tag = "keychain-test.privateKey";
  final String tagBiometric = "keychain-test.privateKeyPresence";
  bool _isRequiresBiometric = false;
  String publicKey = "";

  TextEditingController input = TextEditingController();

  Uint8List encrypted = Uint8List(0);
  Uint8List encryptedWithPublicKey = Uint8List(0);
  String decrypted = "";

  List<String> _listData = [];

  late IosOptions _iosOptions;
  late AndroidOptions _androidOptions;
  late AndroidPromptInfo _androidPromptInfo;

  void saveData() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("datas", _listData);
  }

  void saveBiometric(value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool("authRequired", value);
    setState(() {
      _iosOptions = _iosOptions.copyWith(tag: value ? tagBiometric : tag);
      _androidOptions = _androidOptions.copyWith(
          tag: value ? tagBiometric : tag, authRequired: value);
    });
  }

  void getData() async {
    getData();
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _listData = prefs.getStringList("datas") ?? [];
      _isRequiresBiometric = prefs.getBool("authRequired") ?? false;
      _androidOptions = _androidOptions.copyWith(
          tag: _isRequiresBiometric ? tagBiometric : tag,
          authRequired: _isRequiresBiometric);
      _iosOptions =
          _iosOptions.copyWith(tag: _isRequiresBiometric ? tagBiometric : tag);
    });
  }

  void resetConfig(IosOptions iosOptions, AndroidOptions androidOptions) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
    setState(() {
      _listData = [];
    });
    await _hsmPackage.reset(
        iosOptions: iosOptions, androidOptions: androidOptions);
  }

  @override
  void initState() {
    super.initState();
    getData();
    _androidPromptInfo = AndroidPromptInfo(
        title: "Confirm Biometric",
        confirmationRequired: false,
        negativeButton: "Cancel Auth");
    _iosOptions = IosOptions(
      options: _isRequiresBiometric
          ? [
              AccessControlOption.userPresence,
              AccessControlOption.privateKeyUsage
            ]
          : [AccessControlOption.privateKeyUsage],
      tag: _isRequiresBiometric ? tagBiometric : tag,
    );
    _androidOptions = AndroidOptions(
        authRequired: _isRequiresBiometric,
        tag: _isRequiresBiometric ? tagBiometric : tag,
        androidPromptInfo: _androidPromptInfo,
        oncePrompt: true,
        authValidityDuration: 10);
  }

  void encrypt(String message) {
    _hsmPackage
        .encrypt(
            message: message,
            iosOptions: _iosOptions,
            androidOptions: _androidOptions)
        .then((result) => setState(() {
              encrypted = result ?? Uint8List(0);
              _listData.add(String.fromCharCodes(encrypted));
              saveData();
            }));
  }

  void decrypt(Uint8List message) {
    _hsmPackage
        .decrypt(
            message: message,
            iosOptions: _iosOptions,
            androidOptions: _androidOptions)
        .then((result) => setState(() {
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
                const SizedBox(
                  width: 10,
                ),
                Switch(
                    value: _isRequiresBiometric,
                    onChanged: (value) {
                      setState(() {
                        _isRequiresBiometric = value;
                        encrypted = Uint8List(0);
                        decrypted = "";
                        _iosOptions = _iosOptions.copyWith(
                          tag: value ? tagBiometric : tag,
                          options: value
                              ? [
                                  AccessControlOption.userPresence,
                                  AccessControlOption.privateKeyUsage
                                ]
                              : [AccessControlOption.privateKeyUsage],
                        );
                        _androidOptions = AndroidOptions(
                          authRequired: value,
                          tag: value ? tagBiometric : tag,
                        );
                        resetConfig(_iosOptions, _androidOptions);
                        saveBiometric(value);
                      });
                    }),
              ],
            ),
            TextButton(
                onPressed: () {
                  encrypt(input.text);
                  // input.clear();
                },
                child: Text("encrypt!")),
            Text(encrypted.toString()),
            TextButton(
                onPressed: () {
                  decrypt(encrypted);
                },
                child: Text("decrypt!")),
            Text(decrypted),
            SizedBox(
              height: 20,
            ),
            Text("List Saved Data"),
            Divider(),
            ListView.builder(
              itemCount: _listData.length,
              shrinkWrap: true,
              itemBuilder: (_, idx) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(_listData[idx])),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          decrypt(
                              Uint8List.fromList((_listData[idx]).codeUnits));
                        },
                        child: Text("decrypt"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
