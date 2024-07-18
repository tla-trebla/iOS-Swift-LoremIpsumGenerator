//
//  GenerateLoremIpsumUseCaseTest.swift
//  LoremIpsumGeneratorTests
//
//  Created by Albert Pangestu on 18/07/24.
//

import XCTest

struct GenerateLoremIpsumUseCase {
    var generateCount: Int = 0
    mutating func generateLoremIpsum() {
        generateCount += 1
    }
}

final class GenerateLoremIpsumUseCaseTest: XCTestCase {

    func test_whenInitialize_shouldNotGenerate() {
        let sut = GenerateLoremIpsumUseCase()
        
        XCTAssertEqual(sut.generateCount, 0)
    }
    
    func test_whenGenerate_shouldGenerate() {
        var sut = GenerateLoremIpsumUseCase()
        
        sut.generateLoremIpsum()
        
        XCTAssertEqual(sut.generateCount, 1)
    }
    
    func test_whenGenerateMoreThanOne_shouldGenerateMoreThanOne() {
        var sut = GenerateLoremIpsumUseCase()
        
        sut.generateLoremIpsum()
        sut.generateLoremIpsum()
        
        XCTAssertEqual(sut.generateCount, 2)
    }

}
