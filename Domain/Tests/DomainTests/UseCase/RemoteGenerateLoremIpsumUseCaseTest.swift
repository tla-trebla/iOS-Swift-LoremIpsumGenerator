//
//  RemoteGenerateLoremIpsumUseCaseTest.swift
//  
//
//  Created by Albert Pangestu on 27/07/24.
//

@testable import Domain
import XCTest

final class RemoteGenerateLoremIpsumUseCaseTest: XCTestCase {

    func test_whenInitialize_shouldNotGenerate() {
        let (_, repository) = makeSUT()
        
        XCTAssertEqual(repository.messages, [])
    }
    
    func test_whenGenerate_shouldGenerate() async {
        let (sut, repository) = makeSUT()
        
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(repository.messages, [.generateText])
    }
    
    func test_whenGenerateMoreThanOne_shouldGenerateMoreThanOne() async {
        let (sut, repository) = makeSUT()
        
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(repository.messages, [.generateText, .generateText])
    }
    
    func test_whenFailedToGenerate_shouldReturnError() async throws {
        let error = NSError(domain: "Any Error", code: 1)
        let (sut, _) = makeSUT(result: .failure(error))
        var capturedError: Error?
        
        do {
            _ = try await sut.generateLoremIpsum(numberOfParagraphs: 1)
            XCTFail("Should be error, success is not a correct expectation.")
        } catch {
            capturedError = error
        }
        
        XCTAssertNotNil(capturedError)
    }
    
    func test_whenGenerate_shouldReturnText() async throws {
        let text = TextResponse(text: "Lorem ipsum tincidunt vitae semper quis lectus.\n")
        let (sut, _) = makeSUT(result: .success(text))
        var capturedText: TextResponse?
        
        capturedText = try await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(capturedText, text)
    }
    
    func test_whenGenerateWithInvalidParameter_shouldReturnError() async throws {
        let error: NSError = NSError(domain: "whetever", code: -1)
        let (sut, _) = makeSUT(result: .failure(error))
        var capturedError: GeneralError?
        
        do {
            _ = try await sut.generateLoremIpsum(numberOfParagraphs: -1)
            XCTFail("Should be error, success is not an expectation")
        } catch {
            if let error = error as? GeneralError {
                capturedError = error
            } else {
                XCTFail("Shouldn't pop up this kind of error, this error is not an expectation")
            }
        }
        
        XCTAssertEqual(capturedError, .InvalidParameter)

    }
    
    // MARK: - Helper
    
    func makeSUT(result: Result<TextResponse, Error>) -> (sut: RemoteGenerateLoremIpsumUseCase, GenerateLoremIpsumRepositoryStub) {
        let repository = GenerateLoremIpsumRepositoryStub(result: result)
        let sut = RemoteGenerateLoremIpsumUseCase(repository: repository)
        
        return (sut, repository)
    }
    
    private func makeSUT() -> (sut: RemoteGenerateLoremIpsumUseCase, GenerateLoremIpsumRepositorySpy) {
        let repository = GenerateLoremIpsumRepositorySpy()
        let sut = RemoteGenerateLoremIpsumUseCase(repository: repository)
        
        return (sut, repository)
    }

    final class GenerateLoremIpsumRepositorySpy: GenerateLoremIpsumRepository {
        private(set) var messages = [Message]()
        
        func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
            messages.append(.generateText)
            return TextResponse(text: "")
        }
        
        enum Message {
            case generateText
        }
    }
    
    final class GenerateLoremIpsumRepositoryStub: GenerateLoremIpsumRepository {
        private(set) var result: Result<TextResponse, Error>
        
        init(result: Result<TextResponse, Error>) {
            self.result = result
        }
        
        func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
            try result.get()
        }
    }

}

