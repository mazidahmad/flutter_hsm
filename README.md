


## flutter_hsm

Flutter Hardware Secure Module is a library to encrypt and decrypt data using Hardware Secure Module on any device platform. 
  

## Features

  
 In Apple device, the encryption process use Secure Enclave to secure the data.
 In Android device, the encryption process use Android Keystore with TEE/StrongBox (if device supported) to secure data.

  

## Getting started
  
Complete usage in `/example` folder.

  

```dart

final  _hsmPackage  =  FlutterHardwareSecureModule();
final IosOptions _iosOptions;
final AndroidOptions _androidOptions;
final AndroidPromptInfo _androidPromptInfo;

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
      tag: "TAG",
    );
    _androidOptions = AndroidOptions(
        authRequired: true,
        tag: "TAG",
        androidPromptInfo: _androidPromptInfo,
        oncePrompt: true,
        authValidityDuration: 10);

var encryptedData = _hsmPackage.encrypt(
            message: message,
            iosOptions: _iosOptions,
            androidOptions: _androidOptions)

var decryptedData = _hsmPackage
        .decrypt(
            message: message,
            iosOptions: _iosOptions,
            androidOptions: _androidOptions)
```

  

## Additional information

  Android :
  

 - MainActivity should to extends FlutterFragmentActivity
 - Work on Android API Level >= 23

iOS : 

 - Work on iOS >= 13
