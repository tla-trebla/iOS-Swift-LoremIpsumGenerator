//
//  GenerateLoremIpsumUseCaseTest.swift
//  LoremIpsumGeneratorTests
//
//  Created by Albert Pangestu on 18/07/24.
//

import XCTest

protocol GenerateLoremIpsumRepository {
    func generateLoremIpsum(completion: @escaping(Result<String, Error>) -> Void)
}

struct GenerateLoremIpsumUseCase {
    let repository: GenerateLoremIpsumRepository
    
    init(repository: GenerateLoremIpsumRepository) {
        self.repository = repository
    }
    
    func generateLoremIpsum(completion: @escaping(Result<String, Error>) -> Void) {
        repository.generateLoremIpsum(completion: completion)
    }
}

final class GenerateLoremIpsumUseCaseTest: XCTestCase {

    func test_whenInitialize_shouldNotGenerate() {
        let (_, repository) = makeSUT()
        
        XCTAssertEqual(repository.messages, [])
    }
    
    func test_whenGenerate_shouldGenerate() {
        let (sut, repository) = makeSUT()
        
        sut.generateLoremIpsum { _ in }
        
        XCTAssertEqual(repository.messages, [.generateText])
    }
    
    func test_whenGenerateMoreThanOne_shouldGenerateMoreThanOne() {
        let (sut, repository) = makeSUT()
        
        sut.generateLoremIpsum { _ in }
        sut.generateLoremIpsum { _ in }
        
        XCTAssertEqual(repository.messages, [.generateText, .generateText])
    }
    
    func test_whenFailedToGenerate_shouldReturnError() {
        let error = NSError(domain: "Any Error", code: 1)
        let repository = GenerateLoremIpsumRepositoryStub(result: .failure(error))
        let sut = GenerateLoremIpsumUseCase(repository: repository)
        var capturedError: Error?
        
        sut.generateLoremIpsum { result in
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
        let text = ""
        let repository = GenerateLoremIpsumRepositoryStub(result: .success(text))
        let sut = GenerateLoremIpsumUseCase(repository: repository)
        var capturedText: String?
        
        sut.generateLoremIpsum { result in
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
    private func makeSUT() -> (sut: GenerateLoremIpsumUseCase, GenerateLoremIpsumRepositorySpy) {
        let repository = GenerateLoremIpsumRepositorySpy()
        let sut = GenerateLoremIpsumUseCase(repository: repository)
        
        return (sut, repository)
    }

    final class GenerateLoremIpsumRepositorySpy: GenerateLoremIpsumRepository {
        private(set) var messages = [Message]()
        
        func generateLoremIpsum(completion: @escaping (Result<String, Error>) -> Void) {
            messages.append(.generateText)
        }
        
        enum Message {
            case generateText
        }
    }
    
    final class GenerateLoremIpsumRepositoryStub: GenerateLoremIpsumRepository {
        private(set) var result: Result<String, Error>
        
        init(result: Result<String, Error>) {
            self.result = result
        }
        
        func generateLoremIpsum(completion: @escaping (Result<String, Error>) -> Void) {
            completion(result)
        }
    }

}
