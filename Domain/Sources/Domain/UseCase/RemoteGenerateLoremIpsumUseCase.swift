//
//  RemoteGenerateLoremIpsumUseCase.swift
//  
//
//  Created by Albert Pangestu on 27/07/24.
//

public final class RemoteGenerateLoremIpsumUseCase: GenerateLoremIpsumUseCase {
    let repository: GenerateLoremIpsumRepository
    
    init(repository: GenerateLoremIpsumRepository) {
        self.repository = repository
    }
    
    public init() {
        let client = URLSessionHTTPClient()
        self.repository = RemoteGenerateLoremIpsumRepository(client: client)
    }
    
    public func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
        if numberOfParagraphs < 0 {
            throw GeneralError.InvalidParameter
        }
        return try await repository.generateLoremIpsum(numberOfParagraphs: numberOfParagraphs)
    }
}
