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
      var putResponse : Result<JSON, NSError>!
      var getResponse : Result<JSON, NSError>!
      
      override private func post(path: String, parameters: [String : AnyObject], handler: (Result<JSON, NSError>) -> ()) {
        handler(self.postResponse)
      }

      override private func put(path: String, parameters: [String : AnyObject], handler: (Result<JSON, NSError>) -> ()) {
        handler(self.putResponse)
      }
      
      override private func get(path: String, parameters: [String : AnyObject], handler: (Result<JSON, NSError>) -> ()) {
        handler(self.getResponse)
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
    
    describe(".data") {
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
          mockRequester.postResponse = Result(value: JSON(["data":"blah"]))
          waitUntil { done in
            meshblu.data("uuid", message: ["data":"blah"]) { (result) in
              responseJSON = result.value
              responseError = result.error
              done()
            }
          }
        }
        
        it("should return the message") {
          expect(responseJSON["data"].string) == "blah"
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
            meshblu.data("uuid", message: ["data":"blah"]) { (result) in
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
    
    describe(".data") {
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
          mockRequester.postResponse = Result(value: JSON(["data":"blah"]))
          waitUntil { done in
            meshblu.data("uuid", message: ["data":"blah"]) { (result) in
              responseJSON = result.value
              responseError = result.error
              done()
            }
          }
        }
        
        it("should return the message") {
          expect(responseJSON["data"].string) == "blah"
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
            meshblu.getData("uuid", options: ["data":"blah"]) { (result) in
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
    
    describe(".getData") {
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
          mockRequester.getResponse = Result(value: JSON(["data":"blah"]))
          waitUntil { done in
            meshblu.getData("uuid", options: ["data":"blah"]) { (result) in
              responseJSON = result.value
              responseError = result.error
              done()
            }
          }
        }
        
        it("should return the message") {
          expect(responseJSON["data"].string) == "blah"
        }
        
        it("should not have an error") {
          expect(responseError).to(beNil())
        }
      }
      
      describe("when error") {
        beforeEach {
          let error = NSError()
          mockRequester.getResponse = Result(error: error)
          waitUntil { done in
            meshblu.getData("uuid", options: ["data":"blah"]) { (result) in
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
    
    describe(".getPublicKey") {
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
          mockRequester.getResponse = Result(value: JSON(["publicKey":"blah"]))
          waitUntil { done in
            meshblu.getPublicKey("uuid") { (result) in
              responseJSON = result.value
              responseError = result.error
              done()
            }
          }
        }
        
        it("should return the message") {
          expect(responseJSON["publicKey"].string) == "blah"
        }
        
        it("should not have an error") {
          expect(responseError).to(beNil())
        }
      }
      
      describe("when error") {
        beforeEach {
          let error = NSError()
          mockRequester.getResponse = Result(error: error)
          waitUntil { done in
            meshblu.getPublicKey("uuid") { (result) in
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

    describe(".devices") {
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
            mockRequester.getResponse = Result(value: JSON([["something":"test"]]))
          waitUntil { done in
            meshblu.devices([:]) { (result) in
              responseJSON = result.value
              responseError = result.error
              done()
            }
          }
        }
        
        it("should return a list of devices") {
          expect(responseJSON[0]["something"].string) == "test"
        }
        
        it("should not have an error") {
          expect(responseError).to(beNil())
        }
      }
      
      describe("when error") {
        beforeEach {
          let error = NSError()
          mockRequester.getResponse = Result(error: error)
          waitUntil { done in
            meshblu.devices([:]) { (result) in
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
