//
//  GenerateLoremIpsumUseCaseTest.swift
//  LoremIpsumGeneratorTests
//
//  Created by Albert Pangestu on 18/07/24.
//

@testable import LoremIpsumGenerator
import XCTest

final class GenerateLoremIpsumUseCaseTest: XCTestCase {

    func test_whenInitialize_shouldNotGenerate() {
        let (_, repository) = makeSUT()
        
        XCTAssertEqual(repository.messages, [])
    }
    
    func test_whenGenerate_shouldGenerate() {
        let (sut, repository) = makeSUT()
        
        sut.generateLoremIpsum(numberOfParagraphs: 1) { _ in }
        
        XCTAssertEqual(repository.messages, [.generateText])
    }
    
    func test_whenGenerateMoreThanOne_shouldGenerateMoreThanOne() {
        let (sut, repository) = makeSUT()
        
        sut.generateLoremIpsum(numberOfParagraphs: 1) { _ in }
        sut.generateLoremIpsum(numberOfParagraphs: 1) { _ in }
        
        XCTAssertEqual(repository.messages, [.generateText, .generateText])
    }
    
    func test_whenFailedToGenerate_shouldReturnError() {
        let error = NSError(domain: "Any Error", code: 1)
        let (sut, repository) = makeSUT(result: .failure(error))
        var capturedError: Error?
        
        sut.generateLoremIpsum(numberOfParagraphs: 1) { result in
            switch result {
            case .success:
                XCTFail("Should be error, success is not a correct expectation.")
            case .failure(let error):
                capturedError = error
            }
        }
        
        XCTAssertNotNil(capturedError)
    }
    
    func test_whenGenerate_shouldReturnText() {
        let text = TextResponse(text: "Lorem ipsum tincidunt vitae semper quis lectus.\n")
        let (sut, repository) = makeSUT(result: .success(text))
        var capturedText: TextResponse?
        
        sut.generateLoremIpsum(numberOfParagraphs: 1) { result in
            switch result {
            case .success(let success):
                capturedText = success
            case .failure(let failure):
                XCTFail("Should be success, error is not an expectation")
            }
        }
        
        XCTAssertEqual(capturedText, text)
    }
    
    // MARK: - Helper
    func makeSUT(result: Result<TextResponse, Error>) -> (sut: GenerateLoremIpsumUseCase, GenerateLoremIpsumRepositoryStub) {
        let repository = GenerateLoremIpsumRepositoryStub(result: result)
        let sut = GenerateLoremIpsumUseCase(repository: repository)
        
        return (sut, repository)
    }
    
    private func makeSUT() -> (sut: GenerateLoremIpsumUseCase, GenerateLoremIpsumRepositorySpy) {
        let repository = GenerateLoremIpsumRepositorySpy()
        let sut = GenerateLoremIpsumUseCase(repository: repository)
        
        return (sut, repository)
    }

    final class GenerateLoremIpsumRepositorySpy: GenerateLoremIpsumRepository {
        private(set) var messages = [Message]()
        
        func generateLoremIpsum(numberOfParagraphs: Int, completion: @escaping (Result<TextResponse, Error>) -> Void) {
            messages.append(.generateText)
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
        
        func generateLoremIpsum(numberOfParagraphs: Int, completion: @escaping (Result<TextResponse, Error>) -> Void) {
            completion(result)
        }
    }

}
