//
//  RemoteGenerateLoremIpsumRepository.swift
//  
//
//  Created by Albert Pangestu on 21/07/24.
//

import Foundation

final class RemoteGenerateLoremIpsumRepository: GenerateLoremIpsumRepository {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
        if numberOfParagraphs < 0 {
            throw RepositoryError.InvalidParameter
        }
        let (data, _) = try await requestClient(numberOfParagraphs)
        return try decodeData(data)
    }
    
    private func requestClient(_ numberOfParagraphs: Int) async throws -> (Data, URLResponse) {
        do {
            return try await client.get(numberOfParagraphs: numberOfParagraphs)
        } catch {
            throw RepositoryError.NetworkError
        }
    }
    
    private func decodeData(_ data: Data) throws -> TextResponse {
        do {
            return try JSONDecoder().decode(TextResponse.self, from: data)
        } catch {
            throw RepositoryError.ErrorDecoding
        }
    }
    
    enum RepositoryError: Swift.Error {
        case InvalidParameter
        case NetworkError
        case ErrorDecoding
    }
}

