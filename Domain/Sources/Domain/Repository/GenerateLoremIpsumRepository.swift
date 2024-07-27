//
//  GenerateLoremIpsumRepository.swift
//  
//
//  Created by Albert Pangestu on 27/07/24.
//

protocol GenerateLoremIpsumRepository {
    func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse
}
