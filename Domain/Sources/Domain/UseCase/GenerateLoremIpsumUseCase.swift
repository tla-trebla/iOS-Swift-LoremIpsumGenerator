//
//  GenerateLoremIpsumUseCase.swift
//  
//
//  Created by Albert Pangestu on 27/07/24.
//

public protocol GenerateLoremIpsumUseCase {
    func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse
}
