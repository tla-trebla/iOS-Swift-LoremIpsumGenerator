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
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.inputText, "")
        XCTAssertEqual(sut.generatedText, "")
    }
    
    func test_initiate_useCaseShouldNotRequest() {
        let (_, useCase) = makeSUT()
        
        XCTAssertEqual(useCase.messages, [])
    }
    
    func test_generate_useCaseShouldRequest() async {
        let (sut, useCase) = makeSUT()
        
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(useCase.messages, [.generateText])
    }
    
    func test_generateMoreThanOne_useCaseShouldRequestMoreThanOne() async {
        let (sut, useCase) = makeSUT()
        
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(useCase.messages, [.generateText, .generateText])
    }
    
    // MARK: - Helper
    private func makeSUT() -> (sut: LoremIpsumGeneratorViewModel, GenerateLoremIpsumUseCaseSpy) {
        let useCase = GenerateLoremIpsumUseCaseSpy()
        let sut = LoremIpsumGeneratorViewModel(useCase: useCase)
        
        return (sut, useCase)
    }
    
    final class GenerateLoremIpsumUseCaseSpy: GenerateLoremIpsumUseCase {
        private(set) var messages: [Message] = []
        
        func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
            messages.append(.generateText)
            let data = """
""".data(using: .utf8)!
            return try JSONDecoder().decode(TextResponse.self, from: data)
        }
        
        enum Message {
            case generateText
        }
    }
}
