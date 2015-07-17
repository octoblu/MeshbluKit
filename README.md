# MeshbluKit

<!-- [![CI Status](http://img.shields.io/travis/Sqrt of Octoblu/MeshbluKit.svg?style=flat)](https://travis-ci.org/Sqrt of Octoblu/MeshbluKit) -->
[![Version](https://img.shields.io/cocoapods/v/MeshbluKit.svg?style=flat)](http://cocoapods.org/pods/MeshbluKit)
[![License](https://img.shields.io/cocoapods/l/MeshbluKit.svg?style=flat)](http://cocoapods.org/pods/MeshbluKit)
[![Platform](https://img.shields.io/cocoapods/p/MeshbluKit.svg?style=flat)](http://cocoapods.org/pods/MeshbluKit)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MeshbluKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MeshbluKit"
```
## API

Is device registered
```swift
isNotRegistered() -> Bool
```

Set Credentials
```swift
setCredentials(uuid: String, token: String)
```

Claim Device
```swift
claimDevice(uuid: String, handler: (Result<JSON, NSError>) -> ())
```

Send Data Message
```swift
data(uuid: String, message: [String: AnyObject], handler: (Result<JSON, NSError>) -> ())
```

Register Device
```swift
register(device: [String: AnyObject], handler: (Result<JSON, NSError>) -> ())
```

Send Message
```swift
message(message: [String: AnyObject], handler: (Result<JSON, NSError>) -> ())
```

Update
```swift
update(uuid: String, properties: [String: AnyObject], handler: (Result<JSON, NSError>) -> ())
// OR
update(properties: [String: AnyObject], handler: (Result<JSON, NSError>) -> ())
```

Generate New Session Token
```swift
generateAndStoreToken(uuid: String, handler: (Result<JSON, NSError>) -> ())
```


## Usage:

```swift
import Foundation
import MeshbluKit

class MeshbluExample : AnyObject {
  var meshbluHttp: MeshbluHttp

  init(meshbluConfig: [String: AnyObject]){
    self.meshbluHttp = MeshbluHttp(meshbluConfig: meshbluConfig)
    let uuid = meshbluConfig["uuid"] as? String
    let token = meshbluConfig["token"] as? String
    if uuid != nil && token != nil {
      self.meshbluHttp.setCredentials(uuid!, token: token!)
    }
    super.init()
  }

  init(meshbluHttp: MeshbluHttp) {
    self.meshbluHttp = meshbluHttp
    super.init()
  }

  func getMeshbluClient() -> MeshbluHttp {
    return self.meshbluHttp
  }

  func register() {
    let device = [
      "type": "device:ios-device", // Set your own device type
      "online" : "true"
    ]

    self.meshbluHttp.register(device) { (result) -> () in
      switch result {
      case let .Failure(error):
        println("Failed to register")
      case let .Success(success):
        let json = success.value
        let uuid = json["uuid"].stringValue
        let token = json["token"].stringValue
        println("Register device: uuid: \(uuid) and token: \(token)")

        self.meshbluHttp.setCredentials(uuid, token: token)
      }
    }
  }

  func sendMessage(payload: [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    var message : [String: AnyObject] = [
      "devices" : ["*"],
      "payload" : payload,
      "topic" : "some-topic"
    ]

    self.meshbluHttp.message(message) {
      (result) -> () in
      handler(result)
      self.debugln("Message Sent: \(message)")
    }
  }
}
```


## Author

Sqrt of Octoblu, sqrt@octoblu.com

## License

MeshbluKit is available under the MIT license. See the LICENSE file for more info.
