# Sinch iOS SDK

Welcome to Sinch iOS SDK https://developers.sinch.com/docs/in-app-calling/ios-cloud/ 

Copyright 2014-2022, Sinch Mobile AB (reg. no 556969-5397)


## Features

- Sinch SDK for iOS
- PSTN Calling
     * Make data calls to regular phone numbers
- App-to-App Calling
     * Make and receive voice and video calls
     * Call both native (iOS and Android) and web clients
- Video Calling
     * Make video calls to both native (iOS and Android) and web clients
- Conference Calling

Should you encounter any bugs, glitches, lack of functionality or
other problems using our SDK, please send us an email to dev@sinch.com.
Your help in this regard is greatly appreciated.


## Quick Start

- Install Sinch via CocoaPod (pod 'SinchRTC') or download it at [the download page](https://developers.sinch.com/docs/in-app-calling/sdk-downloads/)

- Read [Getting started guide](https://developers.sinch.com/docs/in-app-calling/getting-started/) at https://developers.sinch.com

- Read Reference Docs (in `docs/`)

- Look at the sample apps inside the SDK package for inspiration

## Documentation

The [User Guide](https://developers.sinch.com/docs/in-app-calling/) includes:

- Instructions for first-time developers
- Using Sinch in your app for making app-to-phone, app-to-app and conference calls
- Using Sinch in your app for making video calls

Reference documentation is available in `docs/`.

## Samples

Sample code is available under `samples/`

- `SinchCallKit.xcodeproj`: App-to-App Calling sample in Objective-C, using VoIP Push Notifications and CallKit
  (This sample requires you to create and upload Apple APNs Signing Key in the Sinch portal.)

- `SinchVideoCallKit.xcodeproj`: App-to-App Video Calling sample in Objective-C, using VoIP Push Notifications and CallKit
  (This sample requires you to create and upload Apple APNs Signing Key in the Sinch portal.)
  
- `SinchVideoCallKitSwift.xcodeproj`: App-to-App Video Calling sample in Swift, using VoIP Push Notifications and CallKit
    (This sample requires you to create and upload Apple APNs Signing Key in the Sinch portal.)

- `SinchPSTN.xcodeproj`: App-to-Phone (PSTN) Calling sample in Objective-C

- `SinchCalling.xcodeproj`: App-to-App Calling sample in Objective-C

- `SinchVideo.xcodeproj`: App-to-App Video calling sample in Objective-C
