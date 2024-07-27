//
//  RemoteGenerateLoremIpsumRepository.swift
//  
//
//  Created by Albert Pangestu on 27/07/24.
//

import Foundation

final class RemoteGenerateLoremIpsumRepository: GenerateLoremIpsumRepository {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
        if numberOfParagraphs < 0 {
            throw GeneralError.InvalidParameter
        }
        let (data, _) = try await requestClient(numberOfParagraphs)
        return try decodeData(data)
    }
    
    private func requestClient(_ numberOfParagraphs: Int) async throws -> (Data, URLResponse) {
        do {
            return try await client.get(with: URL(string: "https://api.api-ninjas.com/v1/loremipsum")!,
                                        numberOfParagraphs: numberOfParagraphs)
        } catch {
            throw GeneralError.NetworkError
        }
    }
    
    private func decodeData(_ data: Data) throws -> TextResponse {
        do {
            return try JSONDecoder().decode(TextResponse.self, from: data)
        } catch {
            throw GeneralError.ErrorDecoding
        }
    }
}

