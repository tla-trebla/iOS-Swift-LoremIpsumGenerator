//
//  HTTPClientInterface.swift
//  LoremIpsumGenerator
//
//  Created by Albert Pangestu on 20/07/24.
//

import Foundation

protocol HTTPClient {
    func get(numberOfParagraphs: Int) async throws -> (Data, URLResponse)
}
