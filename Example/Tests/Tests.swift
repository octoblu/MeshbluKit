// https://github.com/Quick/Quick

import Quick
import Nimble
import Alamofire
import MeshbluKit
import SwiftyJSON

class MeshbluHttpSpec: QuickSpec {
    override func spec() {
        describe(".register") {
            it("works") {
              
              class MockHttpRequester : MeshbluHttpRequester {
                init() {
                  super.init(meshbluUrl: "", uuid: "", token: "")
                }
                
                override private func post(path: String, parameters: [String : AnyObject], handler: (JSON) -> ()) {
                  var data = JSON(["uuid":"123"])
                  handler(data)
                }
              }
              let mockRequester = MockHttpRequester()
              let meshblu = MeshbluHttp(requester: mockRequester)
              
              waitUntil { done in
                meshblu.register({ (data) in
                  let uuid = data["uuid"].stringValue
                  expect(uuid) == "123"
                  done()
                })
              }
          }
        }
    }
}
