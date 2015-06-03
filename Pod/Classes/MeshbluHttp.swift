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
import Result

public class MeshbluHttpRequester {
  var meshbluUrl : String
  var manager : Alamofire.Manager
  
  public init(meshbluUrl: String, uuid: String, token: String){
    self.meshbluUrl = meshbluUrl ?? "https://meshblu.octoblu.com"
    var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
    defaultHeaders["X-Meshblu-UUID"] = uuid
    defaultHeaders["X-Meshblu-Token"] = token
    
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    configuration.HTTPAdditionalHeaders = defaultHeaders
    
    self.manager = Alamofire.Manager(configuration: configuration)
  }
  
  public func post(path : String, parameters : [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    let url = self.meshbluUrl + path
    
    println("About to request")
    
    self.manager.request(.POST, url, parameters: parameters, encoding: .JSON)
      .responseJSON { (request, response, data, error) in
        let json = JSON(data!)
        handler(Result(value: json))
    }
  }}

@objc (MeshbluHttp) public class MeshbluHttp {
  
  public var uuid : String? //= "8f218bb0-8237-11e4-8019-f97967ce66a8"
  public var token : String? //= "4fp9t1uhn6uvj9k9ght5oppvxe83q5mi"
  var httpRequester : MeshbluHttpRequester
  
  public init(meshbluUrl: String) {
    self.httpRequester = MeshbluHttpRequester(meshbluUrl: meshbluUrl, uuid: "", token: "")
  }
  
  public init(requester: MeshbluHttpRequester){
    self.httpRequester = requester
  }
  
  public func register(handler: (Result<JSON, NSError>) -> ()){
    let registrationParameters = ["type": "device:beacon-blu", "online" : "true"]
    self.httpRequester.post("/devices", parameters: registrationParameters) {
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

}