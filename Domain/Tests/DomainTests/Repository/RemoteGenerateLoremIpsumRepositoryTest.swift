//
//  RemoteGenerateLoremIpsumRepositoryTest.swift
//  
//
//  Created by Albert Pangestu on 27/07/24.
//

@testable import Domain
import XCTest

final class RemoteGenerateLoremIpsumRepositoryTest: XCTestCase {

    func test_whenInitialized_shouldNotRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.messages, [])
    }
    
    func test_whenGenerate_shouldCount() async {
        let (sut, client) = makeSUT()
        
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(client.messages, [.getRequest])
    }
    
    func test_whenGenerateMoreThanOne_shouldCountMoreThanOne() async {
        let (sut, client) = makeSUT()
        
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(client.messages, [.getRequest, .getRequest])
    }
    
    func test_whenGenerate_shouldReturnResponse() async throws {
        let jsonData = try! JSONFileLoader.load(fileName: "ThreeParagraphsTextResponse")
        let (data, response) = (jsonData, URLResponse())
        let decodedData = try JSONDecoder().decode(TextResponse.self, from: data)
        let client = HTTPClientStub(result: .success((data, response)))
        let sut = RemoteGenerateLoremIpsumRepository(client: client)
        var capturedText: TextResponse?
        
        do {
            capturedText = try await sut.generateLoremIpsum(numberOfParagraphs: 1)
        } catch {
            XCTFail("Should be success, error is not an expectation")
        }
        
        XCTAssertEqual(capturedText, decodedData)
    }
    
    func test_whenGenerateWithInvalidParameter_shouldReturnError() async throws {
        let error = NSError(domain: "Whatever", code: -1)
        let (sut, _) = makeSUT(result: .failure(error))
        var capturedError: GeneralError?
        
        do {
            _ = try await sut.generateLoremIpsum(numberOfParagraphs: -1)
            XCTFail("Should showing error, success is not an expectation")
        } catch {
            if let error = error as? GeneralError {
                capturedError = error
            } else {
                XCTFail("Should showing the custom error, unknown error is not an expectation")
            }
        }
        
        XCTAssertEqual(capturedError, GeneralError.InvalidParameter)
    }
    
    // MARK: - Helpers
    private func makeSUT(result: Result<(Data, URLResponse), Error>) -> (sut: RemoteGenerateLoremIpsumRepository, HTTPClientStub) {
        let client = HTTPClientStub(result: result)
        let sut = RemoteGenerateLoremIpsumRepository(client: client)
        
        return (sut, client)
    }
    
    private func makeSUT() -> (sut: RemoteGenerateLoremIpsumRepository, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteGenerateLoremIpsumRepository(client: client)
        
        return (sut, client)
    }
    
    final class HTTPClientSpy: HTTPClient {
        private(set) var messages: [Message] = []
        
        func get(with url: URL, numberOfParagraphs: Int) async throws -> (Data, URLResponse) {
            messages.append(.getRequest)
            return (Data(), URLResponse())
        }
        
        enum Message {
            case getRequest
        }
    }
    
    final class HTTPClientStub: HTTPClient {
        private(set) var result: Result<(Data, URLResponse), Error>
        
        init(result: Result<(Data, URLResponse), Error>) {
            self.result = result
        }
        
        func get(with url: URL, numberOfParagraphs: Int) async throws -> (Data, URLResponse) {
            try result.get()
        }
    }
    
    private enum JSONFileLoader {
        static func load(fileName: String) throws -> Data {
            guard let url = Bundle.module.url(forResource: fileName, withExtension: "json") else {
                throw JSONFileLoaderError.FileNotFound
            }
            
            do {
                return try Data(contentsOf: url)
            } catch {
                throw JSONFileLoaderError.CannotDecodeFromURL
            }
        }
        
        enum JSONFileLoaderError: Swift.Error {
            case CannotDecodeFromURL
            case FileNotFound
        }
    }
}
