//
//  MeshbluKit.swift
//  Pods
//
//  Created by Octoblu on 6/1/15.
//
//

import Foundation
import Alamofire

@objc (MeshbluHttp) public class MeshbluHttp {
  
  let meshbluUrl : String = "https://meshblu.octoblu.com"
  
  public var uuid : String? //= "8f218bb0-8237-11e4-8019-f97967ce66a8"
  public var token : String? //= "4fp9t1uhn6uvj9k9ght5oppvxe83q5mi"
  
  public init() {
  }
  
  public func register(onResponse: (responseObj: AnyObject?) -> ()){
    let registrationParameters = ["type": "device:beacon-blu", "online" : "true"]
    self.makeRequest("/devices", parameters: registrationParameters, onResponse: { (responseObj: AnyObject?) in
      if responseObj == nil {
        NSLog("Unable to register")
        return
      }
      NSLog("Device Created")
      self.uuid = responseObj!["uuid"] as! String?
      self.token = (responseObj!["token"] as? String?)!
      let settings = NSUserDefaults.standardUserDefaults()
      settings.setObject(self.uuid, forKey: "deviceUuid")
      settings.setObject(self.token, forKey: "deviceToken")
      onResponse(responseObj: responseObj)
    })
  }
  
  public func makeRequest(path : String, parameters : AnyObject, onResponse: (responseObj: AnyObject?) -> ()){
    
    let url :String = self.meshbluUrl + path
    var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
    defaultHeaders["X-Meshblu-UUID"] = self.uuid!
    defaultHeaders["X-Meshblu-Token"] = self.token!
    
    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    configuration.HTTPAdditionalHeaders = defaultHeaders
    
    let manager = Alamofire.Manager(configuration: configuration)
    
    manager.request(.POST, url, encoding: .JSON)
      .responseJSON { (request, response, data, error) in
        onResponse(responseObj: data)
    }
  }
}