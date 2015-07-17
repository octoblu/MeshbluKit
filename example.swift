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
