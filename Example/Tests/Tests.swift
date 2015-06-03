// https://github.com/Quick/Quick

import Quick
import Nimble
import Alamofire
import MeshbluKit
import Result
import SwiftyJSON

class MeshbluHttpSpec: QuickSpec {
  override func spec() {

    class MockHttpRequester : MeshbluHttpRequester {
      var postResponse : Result<JSON, NSError>!
      
      init() {
        super.init(meshbluConfig: [:])
      }
      
      override private func post(path: String, parameters: [String : AnyObject], handler: (Result<JSON, NSError>) -> ()) {
        handler(self.postResponse)
      }
    }
    
    describe(".register") {
      var mockRequester: MockHttpRequester!
      var responseJSON: JSON!
      var responseError: NSError!
      var meshblu: MeshbluHttp!
      
      beforeEach {
        mockRequester = MockHttpRequester()
        meshblu = MeshbluHttp(requester: mockRequester)
      }
      
      describe("when successful") {
        beforeEach {
          mockRequester.postResponse = Result(value: JSON(["uuid":"123"]))
          waitUntil { done in
            meshblu.register([:]) { (result) in
              responseJSON = result.value
              responseError = result.error
              done()
            }
          }
        }
      
        it("should return the uuid") {
          expect(responseJSON["uuid"].string) == "123"
        }
        
        it("should not have an error") {
          expect(responseError).to(beNil())
        }
      }

      describe("when error") {
        beforeEach {
          let error = NSError()
          mockRequester.postResponse = Result(error: error)
          waitUntil { done in
            meshblu.register([:]) { (result) in
              responseJSON = result.value
              responseError = result.error
              done()
            }
          }
        }
        
        it("should not return a value") {
          expect(responseJSON).to(beNil())
        }
        
        it("should have an error") {
          expect(responseError).to(beAKindOf(NSError))
        }
      }
    }

    
    describe(".message") {
      var mockRequester: MockHttpRequester!
      var responseJSON: JSON!
      var responseError: NSError!
      var meshblu: MeshbluHttp!
      
      beforeEach {
        mockRequester = MockHttpRequester()
        meshblu = MeshbluHttp(requester: mockRequester)
      }
      
      describe("when successful") {
        beforeEach {
          mockRequester.postResponse = Result(value: JSON(["devices":["*"], "topic":"test"]))
          waitUntil { done in
            meshblu.message(["devices":["*"], "topic":"test"]) { (result) in
              responseJSON = result.value
              responseError = result.error
              done()
            }
          }
        }
        
        it("should return the message") {
          expect(responseJSON["topic"].string) == "test"
        }
        
        it("should not have an error") {
          expect(responseError).to(beNil())
        }
      }
      
      describe("when error") {
        beforeEach {
          let error = NSError()
          mockRequester.postResponse = Result(error: error)
          waitUntil { done in
            meshblu.message(["devices":["*"], "topic":"test"]) { (result) in
              responseJSON = result.value
              responseError = result.error
              done()
            }
          }
        }
        
        it("should not return a value") {
          expect(responseJSON).to(beNil())
        }
        
        it("should have an error") {
          expect(responseError).to(beAKindOf(NSError))
        }
      }
      
    }
  }
}
