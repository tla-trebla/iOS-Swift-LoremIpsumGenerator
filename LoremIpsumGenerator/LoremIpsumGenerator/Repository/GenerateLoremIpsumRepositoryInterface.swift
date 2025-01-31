//
//  GenerateLoremIpsumRepositoryInterface.swift
//  LoremIpsumGenerator
//
//  Created by Albert Pangestu on 19/07/24.
//

protocol GenerateLoremIpsumRepository {
    func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse
}
