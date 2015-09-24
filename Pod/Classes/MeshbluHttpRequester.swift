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
      .responseJSON { (_, _, result) in
        if result.error != nil || result.value == nil {
          handler(Result(error: result.error))
        }else{
          let json = JSON(result.value!)
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
      .responseJSON { (_, _, result) in
        if result.error != nil || result.value == nil {
          handler(Result(error: result.error))
        }else{
          let json = JSON(result.value!)
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
      .responseJSON { (_, _, result) in
        if result.error != nil || result.value == nil {
          handler(Result(error: result.error))
        }else{
          let json = JSON(result.value!)
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
      .responseJSON { (_, _, result) in
        if result.error != nil || result.value == nil {
          handler(Result(error: result.error))
        }else{
          let json = JSON(result.value!)
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
      .responseJSON { (_, _, result) in
        if result.error != nil || result.value == nil {
          handler(Result(error: result.error))
        }else{
          let json = JSON(result.value!)
          handler(Result(value: json))
        }
      }
  }
}
