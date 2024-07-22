//
//  RemoteGenerateLoremIpsumUseCase.swift
//
//
//  Created by Albert Pangestu on 21/07/24.
//

final class RemoteGenerateLoremIpsumUseCase {
    let repository: GenerateLoremIpsumRepository
    
    init(repository: GenerateLoremIpsumRepository) {
        self.repository = repository
    }
    
    func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
        if numberOfParagraphs < 0 {
            throw GeneralError.InvalidParameter
        }
        return try await repository.generateLoremIpsum(numberOfParagraphs: numberOfParagraphs)
    }
}
