//
//  URLSessionHTTPClient.swift
//  
//
//  Created by Albert Pangestu on 27/07/24.
//

import Foundation

final class URLSessionHTTPClient: HTTPClient {
    func get(with url: URL, numberOfParagraphs: Int) async throws -> (Data, URLResponse) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "paragraphs", value: "\(numberOfParagraphs)")
        ]
        
        guard let finalURL = urlComponents?.url else {
            throw GeneralError.InvalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.setValue("rmDFmbXrxKdv3wqA7HleqA==wDdWGXRjvQ4C3Bbu", forHTTPHeaderField: "X-Api-Key")
        
        return try await URLSession.shared.data(for: request)
    }
}
