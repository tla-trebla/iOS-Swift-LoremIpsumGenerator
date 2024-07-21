//
//  TextResponse.swift
//
//
//  Created by Albert Pangestu on 21/07/24.
//

struct TextResponse: Decodable, Equatable {
    let text: String
    
    var paragraphs: [String] {
        text.split(separator: "\n").map(String.init)
    }
    var numberOfParagraphs: Int {
        paragraphs.count
    }
}
