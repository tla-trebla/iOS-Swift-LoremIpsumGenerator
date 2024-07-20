//
//  GenerateLoremIpsumUseCase.swift
//  LoremIpsumGenerator
//
//  Created by Albert Pangestu on 19/07/24.
//

final class GenerateLoremIpsumUseCase {
    let repository: GenerateLoremIpsumRepository
    
    init(repository: GenerateLoremIpsumRepository) {
        self.repository = repository
    }
    
    func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
        if numberOfParagraphs < 0 {
            throw ErrorGenerate.invalidNumberOfParagraphsInput
        }
        return try await repository.generateLoremIpsum(numberOfParagraphs: numberOfParagraphs)
    }
}

enum ErrorGenerate: Error {
    case invalidNumberOfParagraphsInput
}
