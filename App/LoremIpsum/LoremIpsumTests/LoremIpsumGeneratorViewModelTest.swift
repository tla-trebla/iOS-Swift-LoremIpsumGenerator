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
    
    func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
        try await useCase.generateLoremIpsum(numberOfParagraphs: numberOfParagraphs)
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
    
    func test_generate_useCaseShouldRequest() async {
        let useCase = GenerateLoremIpsumUseCaseSpy()
        let sut = LoremIpsumGeneratorViewModel(useCase: useCase)
        
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(useCase.requestCount, 1)
    }
    
    // MARK: - Helper
    final class GenerateLoremIpsumUseCaseSpy: GenerateLoremIpsumUseCase {
        private(set) var requestCount: Int = 0
        
        func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
            requestCount = 1
            let data = """
""".data(using: .utf8)!
            return try JSONDecoder().decode(TextResponse.self, from: data)
        }
    }
}
