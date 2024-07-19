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
        return TextResponse(text: "")
    }
}

protocol HTTPClient {}

final class RemoteGenerateLoremIpsumRepositoryTest: XCTestCase {

    func test_whenInitialized_shouldNotRequest() {
        let client = HTTPClientSpy()
        let sut = RemoteGenerateLoremIpsumRepository(client: client)
        
        XCTAssertEqual(client.requestCount, 0)
    }
    
    // MARK: - Helpers
    final class HTTPClientSpy: HTTPClient {
        let requestCount: Int = 0
    }
}
