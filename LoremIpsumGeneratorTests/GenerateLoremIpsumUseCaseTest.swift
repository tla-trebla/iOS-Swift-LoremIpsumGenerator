//
//  GenerateLoremIpsumUseCaseTest.swift
//  LoremIpsumGeneratorTests
//
//  Created by Albert Pangestu on 18/07/24.
//

import XCTest

struct GenerateLoremIpsumUseCase {
    let generateCount: Int = 0
}

final class GenerateLoremIpsumUseCaseTest: XCTestCase {

    func test_whenInitialize_shouldNotGenerate() {
        let sut = GenerateLoremIpsumUseCase()
        
        XCTAssertEqual(sut.generateCount, 0)
    }

}
