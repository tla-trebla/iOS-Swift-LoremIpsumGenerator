//
//  HTTPClientInterface.swift
//  
//
//  Created by Albert Pangestu on 27/07/24.
//

import Foundation

protocol HTTPClient {
    func get(with url: URL, numberOfParagraphs: Int) async throws -> (Data, URLResponse)
}
