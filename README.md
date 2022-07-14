


## flutter_hsm

Flutter Hardware Secure Module is a library to encrypt and decrypt data using Hardware Secure Module on any device platform. 
  

## Features

  
 In Apple device, the encryption process use Secure Enclave to secure the data.
 In Android device, the encryption process use Android Keystore with TEE/StrongBox (if device supported) to secure data.

  

## Getting started
  
Complete usage in `/example` folder.

  

```dart

final  _hsmPackage  =  FlutterHardwareSecureModule();

var encryptedData = _hsmPackage.encrypt(message:  "A string to encrypt", accessControl:  AccessControlHsm(options [AccessControlOption.userPresence, AccessControlOption.privateKeyUsage] authRequired:  true, tag: "TAG",))

var decryptedData = _hsmPackage.decrypt(message:  encryptedData, accessControl:  AccessControlHsm(options [AccessControlOption.userPresence, AccessControlOption.privateKeyUsage],
authRequired:  true, tag: "TAG",))
```

  

## Additional information

  Android :
  

 - MainActivity should to extends FlutterFragmentActivity
 - Work on Android API Level >= 23

iOS : 

 - Work on iOS >= 13
