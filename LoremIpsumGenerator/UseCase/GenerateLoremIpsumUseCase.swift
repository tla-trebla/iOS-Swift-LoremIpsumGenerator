//
//  GenerateLoremIpsumUseCase.swift
//  LoremIpsumGenerator
//
//  Created by Albert Pangestu on 19/07/24.
//

struct GenerateLoremIpsumUseCase {
    let repository: GenerateLoremIpsumRepository
    
    init(repository: GenerateLoremIpsumRepository) {
        self.repository = repository
    }
    
    func generateLoremIpsum(numberOfParagraphs: Int, completion: @escaping(Result<TextResponse, Error>) -> Void) {
        repository.generateLoremIpsum(numberOfParagraphs: numberOfParagraphs, completion: completion)
    }
}
