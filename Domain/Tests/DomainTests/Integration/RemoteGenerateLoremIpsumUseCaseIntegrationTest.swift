//
//  RemoteGenerateLoremIpsumUseCaseIntegrationTest.swift
//  
//
//  Created by Albert Pangestu on 03/08/24.
//

@testable import Domain
import XCTest

final class RemoteGenerateLoremIpsumUseCaseIntegrationTest: XCTestCase {

    func test_generate_receiveGeneratedText() async throws {
        let client = URLSessionHTTPClient()
        let repository = RemoteGenerateLoremIpsumRepository(client: client)
        let sut = RemoteGenerateLoremIpsumUseCase(repository: repository)
        var capturedTextResponse: TextResponse?
        let expectation = expectation(description: "Text Generated")
        
        do {
            capturedTextResponse = try await sut.generateLoremIpsum(numberOfParagraphs: 1)
            expectation.fulfill()
        } catch {
            XCTFail("Expected a success, it shows an error: \(error.localizedDescription)")
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
        XCTAssertNotNil(capturedTextResponse)
    }

}
