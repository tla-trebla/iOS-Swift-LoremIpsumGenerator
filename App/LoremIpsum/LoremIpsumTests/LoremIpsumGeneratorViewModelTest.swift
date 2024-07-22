//
//  LoremIpsumGeneratorViewModelTest.swift
//  LoremIpsumTests
//
//  Created by Albert Pangestu on 21/07/24.
//

import XCTest
import LoremIpsumLib

final class LoremIpsumGeneratorViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var generatedText: String = ""
    
    private let useCase: GenerateLoremIpsumUseCase
    
    init(useCase: GenerateLoremIpsumUseCase) {
        self.useCase = useCase
    }
}

final class LoremIpsumGeneratorViewModelTest: XCTestCase {

    func test_initiate_textFieldShouldEmpty() {
        let useCase = GenerateLoremIpsumUseCaseSpy()
        let sut = LoremIpsumGeneratorViewModel(useCase: useCase)
        
        XCTAssertEqual(sut.inputText, "")
        XCTAssertEqual(sut.generatedText, "")
    }
    
    func test_initiate_useCaseShouldNotRequest() {
        let useCase = GenerateLoremIpsumUseCaseSpy()
        let sut = LoremIpsumGeneratorViewModel(useCase: useCase)
        
        XCTAssertEqual(useCase.requestCount, 0)
    }
    
    // MARK: - Helper
    final class GenerateLoremIpsumUseCaseSpy: GenerateLoremIpsumUseCase {
        let requestCount: Int = 0
        
        func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
            let data = """
""".data(using: .utf8)!
            return try JSONDecoder().decode(TextResponse.self, from: data)
        }
    }
}
