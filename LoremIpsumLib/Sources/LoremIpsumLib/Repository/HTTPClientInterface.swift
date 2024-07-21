//
//  HTTPClientInterface.swift
//
//
//  Created by Albert Pangestu on 21/07/24.
//

import Foundation

protocol HTTPClient {
    func get(numberOfParagraphs: Int) async throws -> (Data, URLResponse)
}
