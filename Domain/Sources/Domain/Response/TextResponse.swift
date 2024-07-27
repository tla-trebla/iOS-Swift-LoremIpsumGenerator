//
//  TextResponse.swift
//  
//
//  Created by Albert Pangestu on 27/07/24.
//

public struct TextResponse: Decodable, Equatable {
    public let text: String
    
    var paragraphs: [String] {
        text.split(separator: "\n").map(String.init)
    }
    var numberOfParagraphs: Int {
        paragraphs.count
    }
}

