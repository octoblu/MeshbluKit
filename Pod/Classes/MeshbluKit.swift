//
//  MeshbluKit.swift
//  Pods
//
//  Created by Octoblu on 6/1/15.
//
//

import Foundation
import AFNetworking

@objc (MeshbluKit) public class MeshbluKit {
  
  let meshbluUrl : String = "https://meshblu.octoblu.com"
  
  public var uuid : String? //= "8f218bb0-8237-11e4-8019-f97967ce66a8"
  public var token : String? //= "4fp9t1uhn6uvj9k9ght5oppvxe83q5mi"
  
  public init() {
  }
  
  public func register(onResponse: (responseObj: Dictionary<String, AnyObject>?) -> ()){
    let registrationParameters = ["type": "device:beacon-blu", "online" : "true"]
    self.makeRequest("/devices", parameters: registrationParameters, onResponse: { (responseObj: Dictionary<String, AnyObject>?) in
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
  
  public func makeRequest(path : String, parameters : AnyObject, onResponse: (responseObj: Dictionary<String, AnyObject>?) -> ()){
    let manager :AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
    let url :String = self.meshbluUrl + path
    
    // Request Success
    let requestSuccess = {
      (operation :AFHTTPRequestOperation!, responseObject :AnyObject!) -> Void in
      
      //SVProgressHUD.showSuccessWithStatus("Sent!")
      let dictResponse = responseObject as! Dictionary<String, AnyObject>?
      onResponse(responseObj: dictResponse);
      NSLog("requestSuccess \(responseObject)")
    }
    
    // Request Failure
    let requestFailure = {
      (operation :AFHTTPRequestOperation!, error :NSError!) -> Void in
      
      //SVProgressHUD.showErrorWithStatus("Error!")
      onResponse(responseObj: nil);
      NSLog("requestFailure: \(error)")
    }
    
    //SVProgressHUD.showWithStatus("Triggering...")
    // Set Headers
    if self.uuid != nil && self.token != nil {
      manager.requestSerializer.setValue(self.uuid!, forHTTPHeaderField: "skynet_auth_uuid")
      manager.requestSerializer.setValue(self.token!, forHTTPHeaderField: "skynet_auth_token")
    }
    
    manager.POST(url, parameters: parameters, success: requestSuccess, failure: requestFailure)
  }
}