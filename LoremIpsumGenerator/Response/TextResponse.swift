//
//  TextResponse.swift
//  LoremIpsumGenerator
//
//  Created by Albert Pangestu on 19/07/24.
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
