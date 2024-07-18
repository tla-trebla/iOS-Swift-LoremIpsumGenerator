//
//  GenerateLoremIpsumUseCaseTest.swift
//  LoremIpsumGeneratorTests
//
//  Created by Albert Pangestu on 18/07/24.
//

import XCTest

protocol GenerateLoremIpsumRepository {
    func generateLoremIpsum()
}

struct GenerateLoremIpsumUseCase {
    let repository: GenerateLoremIpsumRepository
    
    init(repository: GenerateLoremIpsumRepository) {
        self.repository = repository
    }
    
    func generateLoremIpsum() {
        repository.generateLoremIpsum()
    }
}

final class GenerateLoremIpsumUseCaseTest: XCTestCase {

    func test_whenInitialize_shouldNotGenerate() {
        let repository = GenerateLoremIpsumRepositorySpy()
        let sut = GenerateLoremIpsumUseCase(repository: repository)
        
        XCTAssertEqual(repository.generateCount, 0)
    }
    
    func test_whenGenerate_shouldGenerate() {
        let repository = GenerateLoremIpsumRepositorySpy()
        var sut = GenerateLoremIpsumUseCase(repository: repository)
        
        sut.generateLoremIpsum()
        
        XCTAssertEqual(repository.generateCount, 1)
    }
    
    func test_whenGenerateMoreThanOne_shouldGenerateMoreThanOne() {
        let repository = GenerateLoremIpsumRepositorySpy()
        var sut = GenerateLoremIpsumUseCase(repository: repository)
        
        sut.generateLoremIpsum()
        sut.generateLoremIpsum()
        
        XCTAssertEqual(repository.generateCount, 2)
    }
    
    func test_generateWithTextIncluded_shouldReturnText() {
        
    }

}

// MARK: - Helper

final class GenerateLoremIpsumRepositorySpy: GenerateLoremIpsumRepository {
    private(set) var generateCount = 0
    
    func generateLoremIpsum() {
        generateCount += 1
    }
}
