//
//  MeshbluKit.swift
//  Pods
//
//  Created by Octoblu on 6/1/15.
//
//

import Foundation
import Alamofire
import SwiftyJSON

public class MeshbluHttpRequester {
  let host : String
  let port : Int

  public init(host : String, port : Int){
    self.host = host
    self.port = port
  }

  public convenience init(){
    self.init(host: "meshblu.octoblu.com", port: 443)
  }

  public convenience init(meshbluConfig: [String: AnyObject]){
    self.init(host: "example", port: 1)
  }

  private func getManager() -> Manager {
    return Alamofire.Manager.sharedInstance
  }

  public func setDefaultHeaders(uuid : String, token : String) {
    var defaultHeaders = getManager().session.configuration.HTTPAdditionalHeaders ?? [:]
    defaultHeaders["meshblu_auth_uuid"] = uuid
    defaultHeaders["meshblu_auth_token"] = token

    getManager().session.configuration.HTTPAdditionalHeaders = defaultHeaders
  }

  public func delete(path : String, parameters : [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    let urlComponent = NSURLComponents()
    urlComponent.port = self.port
    urlComponent.host = self.host
    urlComponent.scheme = urlComponent.port == 443 ? "https" : "http"
    urlComponent.path = path
    let url = urlComponent.string!

    getManager().request(.DELETE, url, parameters: parameters)
      .responseJSON { (request, response, data, error) -> Void in
        if error != nil || data == nil {
          let error = NSError(domain: "com.octoblu.meshblu", code: 500, userInfo: [:])
          handler(Result(error: error))
        }else{
          let json = JSON(data!)
          handler(Result(value: json))
        }
    }
  }

  public func get(path : String, parameters : [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    let urlComponent = NSURLComponents()
    urlComponent.port = self.port
    urlComponent.host = self.host
    urlComponent.scheme = urlComponent.port == 443 ? "https" : "http"
    urlComponent.path = path
    let url = urlComponent.string!

    getManager().request(.GET, url, parameters: parameters)
      .responseJSON { (request, response, data, error) -> Void in 
        if error != nil || data == nil {
          let error = NSError(domain: "com.octoblu.meshblu", code: 500, userInfo: [:])
          handler(Result(error: error))
        }else{
          let json = JSON(data!)
          handler(Result(value: json))
        }
    }
  }

  public func patch(path : String, parameters : [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    let urlComponent = NSURLComponents()
    urlComponent.port = self.port
    urlComponent.host = self.host
    urlComponent.scheme = urlComponent.port == 443 ? "https" : "http"
    urlComponent.path = path
    let url = urlComponent.string!

    getManager().request(.PATCH, url, parameters: parameters)
      .responseJSON { (request, response, data, error) -> Void in
        if error != nil || data == nil {
          let error = NSError(domain: "com.octoblu.meshblu", code: 500, userInfo: [:])
          handler(Result(error: error))
        }else{
          let json = JSON(data!)
          handler(Result(value: json))
        }
    }
  }

  public func post(path : String, parameters : [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    let urlComponent = NSURLComponents()
    urlComponent.port = self.port
    urlComponent.host = self.host
    urlComponent.scheme = urlComponent.port == 443 ? "https" : "http"
    urlComponent.path = path
    let url = urlComponent.string!

    getManager().request(.POST, url, parameters: parameters)
      .responseJSON { (request, response, data, error) -> Void in
        if error != nil || data == nil {
          let error = NSError(domain: "com.octoblu.meshblu", code: 500, userInfo: [:])
          handler(Result(error: error))
        }else{
          let json = JSON(data!)
          handler(Result(value: json))
        }
    }
  }

  public func put(path : String, parameters : [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    let urlComponent = NSURLComponents()
    urlComponent.port = self.port
    urlComponent.host = self.host
    urlComponent.scheme = urlComponent.port == 443 ? "https" : "http"
    urlComponent.path = path
    let url = urlComponent.string!

    getManager().request(.PUT, url, parameters: parameters)
      .responseJSON { (request, response, data, error) -> Void in
        if error != nil || data == nil {
          let error = NSError(domain: "com.octoblu.meshblu", code: 500, userInfo: [:])
          handler(Result(error: error))
        }else{
          let json = JSON(data!)
          handler(Result(value: json))
        }
    }
  }
}

public class MeshbluHttp {
  var httpRequester : MeshbluHttpRequester
  var meshbluConfig : [String: AnyObject] = [:]

  public init(meshbluConfig: [String: AnyObject]) {
    self.meshbluConfig = meshbluConfig
    self.httpRequester = MeshbluHttpRequester()
  }

  public init(requester: MeshbluHttpRequester) {
    self.httpRequester = requester
  }

  public func isNotRegistered() -> Bool {
    return self.meshbluConfig["uuid"] == nil
  }

  public func setCredentials(uuid: String, token: String) {
    self.meshbluConfig.updateValue(uuid, forKey: "uuid")
    self.meshbluConfig.updateValue(token, forKey: "token")
    self.httpRequester.setDefaultHeaders(uuid, token: token)
  }

  public func claimDevice(uuid: String, handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.put("/claimdevice/\(uuid)", parameters: [:]) {
      (result) -> () in

      handler(result)
    }
  }

  public func data(uuid: String, message: [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.post("/data/\(uuid)", parameters: message) {
      (result) -> () in

      handler(result)
    }
  }

  public func deleteDevice(uuid: String, handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.delete("/devices/\(uuid)", parameters: [:]) {
      (result) -> () in

      handler(result)
    }
  }

  public func devices(options: [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.get("/v2/devices", parameters: options) {
      (result) -> () in

      handler(result)
    }
  }

  public func generateToken(uuid: String, handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.post("/devices/\(uuid)/tokens", parameters: [:]) {
      (result) -> () in

      handler(result)
    }
  }

  public func getData(uuid: String, options: [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.get("/data/\(uuid)", parameters: options) {
      (result) -> () in

      handler(result)
    }
  }

  public func getPublicKey(uuid: String, handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.get("/devices/\(uuid)/publickey", parameters: [:]) {
      (result) -> () in

      handler(result)
    }
  }

  public func register(device: [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.post("/devices", parameters: device) {
      (result) -> () in

      handler(result)
    }
  }

  public func resetToken(uuid: String, handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.post("/devices/\(uuid)/token", parameters: [:]) {
      (result) -> () in

      handler(result)
    }
  }

  public func message(message: [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.post("/messages", parameters: message) {
      (result) -> () in

      handler(result)
    }
  }

  public func update(uuid: String, properties: [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.patch("/v2/devices/\(uuid)", parameters: properties) {
      (result) -> () in

      handler(result)
    }
  }

  public func update(properties: [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    let uuid = self.meshbluConfig["uuid"] as! String
    update(uuid, properties: properties, handler: handler);
  }

  public func updateDangerously(uuid: String, properties: [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.put("/v2/devices/\(uuid)", parameters: properties) {
      (result) -> () in

      handler(result)
    }
  }

  public func whoami(handler: (Result<JSON, NSError>) -> ()){
    self.httpRequester.get("/v2/whoami", parameters: [:]) {
      (result) -> () in

      handler(result)
    }
  }

}
