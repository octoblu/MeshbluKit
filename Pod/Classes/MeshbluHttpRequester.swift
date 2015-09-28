import Foundation
import Alamofire
import SwiftyJSON

public class MeshbluHttpRequester {
  let host : String
  let port : Int
  var manager : Alamofire.Manager

  public init(host : String, port : Int){
    self.host = host
    self.port = port
    self.manager = Alamofire.Manager.sharedInstance
  }

  public convenience init(){
    self.init(host: "meshblu.octoblu.com", port: 443)
  }

  public convenience init(meshbluConfig: [String: AnyObject]){
    self.init(host: "example", port: 1)
  }

  public func setDefaultHeaders(uuid : String, token : String) {
    var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]

    defaultHeaders["meshblu_auth_uuid"] = uuid
    defaultHeaders["meshblu_auth_token"] = token

    let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
    configuration.HTTPAdditionalHeaders = defaultHeaders
    self.manager = Alamofire.Manager(configuration: configuration)
  }

  private func getRequest(method: String, path : String, parameters : [String: AnyObject]) -> Request {
    let urlComponent = NSURLComponents()
    urlComponent.port = self.port
    urlComponent.host = self.host
    urlComponent.scheme = urlComponent.port == 443 ? "https" : "http"
    urlComponent.path = path
    let url = urlComponent.string!
    switch method {
      case "DELETE":
        return self.manager.request(.DELETE, url, parameters: parameters, encoding: .JSON)
      case "POST":
        return self.manager.request(.POST, url, parameters: parameters, encoding: .JSON)
      case "GET":
        return self.manager.request(.GET, url, parameters: parameters, encoding: .JSON)
      case "PUT":
        return self.manager.request(.PUT, url, parameters: parameters, encoding: .JSON)
      case "PATCH":
        return self.manager.request(.PATCH, url, parameters: parameters, encoding: .JSON)
      default:
        return self.manager.request(.GET, url, parameters: parameters, encoding: .JSON)
    }

  }

  private func handleResult(result: Alamofire.Result<AnyObject>, handler: (Result<JSON, NSError>) -> ()){
    if result.isFailure {
      let error = NSError(domain: "com.octoblu.meshblu", code: 500, userInfo: [NSLocalizedFailureReasonErrorKey: "\(result.error)"])
      handler(Result(error: error))
      return
    }
    let json = JSON(result.value!)
    handler(Result(value: json))
  }

  public func delete(path : String, parameters : [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.getRequest("DELETE", path: path, parameters: parameters).responseJSON { (_, _, result) in
      self.handleResult(result, handler: handler)
    }
  }

  public func get(path : String, parameters : [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.getRequest("GET", path: path, parameters: parameters).responseJSON { (_, _, result) in
      self.handleResult(result, handler: handler)
    }
  }

  public func patch(path : String, parameters : [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.getRequest("PATCH", path: path, parameters: parameters).responseJSON { (_, _, result) in
      self.handleResult(result, handler: handler)
    }
  }

  public func post(path : String, parameters : [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.getRequest("POST", path: path, parameters: parameters).responseJSON { (_, _, result) in
      self.handleResult(result, handler: handler)
    }
  }

  public func put(path : String, parameters : [String: AnyObject], handler: (Result<JSON, NSError>) -> ()){
    self.getRequest("PUT", path: path, parameters: parameters).responseJSON { (_, _, result) in
      self.handleResult(result, handler: handler)
    }
  }
}
