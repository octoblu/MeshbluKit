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

  private func getRequest(method: String, path : String, parameters : [String: AnyObject]) -> Request {
    let urlComponent = NSURLComponents()
    urlComponent.port = self.port
    urlComponent.host = self.host
    urlComponent.scheme = urlComponent.port == 443 ? "https" : "http"
    urlComponent.path = path
    let url = urlComponent.string!
    switch method {
      case "DELETE":
        return getManager().request(.DELETE, url, parameters: parameters, encoding: .JSON)
      case "POST":
        return getManager().request(.POST, url, parameters: parameters, encoding: .JSON)
      case "GET":
        return getManager().request(.GET, url, parameters: parameters, encoding: .JSON)
      case "PUT":
        return getManager().request(.PUT, url, parameters: parameters, encoding: .JSON)
      case "PATCH":
        return getManager().request(.PATCH, url, parameters: parameters, encoding: .JSON)
      default:
        return getManager().request(.GET, url, parameters: parameters, encoding: .JSON)
    }

  }

  private func handleResult(result: Alamofire.Result<AnyObject>, handler: (Result<JSON, NSError>) -> ()){
    if result.isFailure {
      let error = NSError(domain: "com.octoblu.meshblu", code: 500, userInfo: [NSLocalizedFailureReasonErrorKey: result.error])
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
