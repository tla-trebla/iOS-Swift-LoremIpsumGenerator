//
//  RemoteGenerateLoremIpsumRepositoryTest.swift
//  LoremIpsumGeneratorTests
//
//  Created by Albert Pangestu on 19/07/24.
//

@testable import LoremIpsumGenerator
import XCTest

class RemoteGenerateLoremIpsumRepository: GenerateLoremIpsumRepository {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
        if numberOfParagraphs < 0 {
            throw ErrorGenerate.invalidNumberOfParagraphsInput
        }
        return try await client.get(numberOfParagraphs: numberOfParagraphs)
    }
}

protocol HTTPClient {
    func get(numberOfParagraphs: Int) async throws -> TextResponse
}

final class RemoteGenerateLoremIpsumRepositoryTest: XCTestCase {

    func test_whenInitialized_shouldNotRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestCount, 0)
    }
    
    func test_whenGenerate_shouldCount() async {
        let (sut, client) = makeSUT()
        
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(client.requestCount, 1)
    }
    
    func test_whenGenerateMoreThanOne_shouldCountMoreThanOne() async {
        let (sut, client) = makeSUT()
        
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(client.requestCount, 2)
    }
    
    func test_whenGenerate_shouldReturnResponse() async throws {
        let text = TextResponse(text: "Lorem ipsum tincidunt vitae semper quis lectus.\n")
        let (sut, client) = makeSUT(result: .success(text))
        var capturedText: TextResponse?
        
        do {
            capturedText = try await sut.generateLoremIpsum(numberOfParagraphs: 1)
        } catch {
            XCTFail("Should be success, error is not an expectation")
        }
        
        XCTAssertEqual(capturedText, text)
    }
    
    func test_whenGenerateWithInvalidParameter_shouldReturnError() async throws {
        let error = NSError(domain: "Whatever", code: -1)
        let (sut, client) = makeSUT(result: .failure(error))
        var capturedError: ErrorGenerate?
        
        do {
            _ = try await sut.generateLoremIpsum(numberOfParagraphs: -1)
            XCTFail("Should showing error, success is not an expectation")
        } catch {
            if let error = error as? ErrorGenerate {
                capturedError = error
            } else {
                XCTFail("Should showing the custom error, unknown error is not an expectation")
            }
        }
        
        XCTAssertEqual(capturedError, ErrorGenerate.invalidNumberOfParagraphsInput)
    }
    
    // MARK: - Helpers
    private func makeSUT(result: Result<TextResponse, Error>) -> (sut: RemoteGenerateLoremIpsumRepository, HTTPClientStub) {
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
        private(set) var requestCount: Int = 0
        
        func get(numberOfParagraphs: Int) async throws -> TextResponse {
            requestCount += 1
            return TextResponse(text: "")
        }
    }
    
    final class HTTPClientStub: HTTPClient {
        private(set) var result: Result<TextResponse, Error>
        
        init(result: Result<TextResponse, Error>) {
            self.result = result
        }
        
        func get(numberOfParagraphs: Int) async throws -> TextResponse {
            try result.get()
        }
    }
}
