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
    
    func generateLoremIpsum(numberOfParagraphs: Int) async throws -> LoremIpsumGenerator.TextResponse {
        client.get()
        return TextResponse(text: "")
    }
}

protocol HTTPClient {
    func get()
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
    
    // MARK: - Helpers
    private func makeSUT() -> (sut: RemoteGenerateLoremIpsumRepository, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteGenerateLoremIpsumRepository(client: client)
        
        return (sut, client)
    }
    
    final class HTTPClientSpy: HTTPClient {
        private(set) var requestCount: Int = 0
        
        func get() {
            requestCount += 1
        }
    }
}
