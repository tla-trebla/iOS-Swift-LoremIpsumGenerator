//
//  LoremIpsumGeneratorViewModelTest.swift
//  LoremIpsumTests
//
//  Created by Albert Pangestu on 21/07/24.
//

import XCTest

final class LoremIpsumGeneratorViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var generatedText: String = ""
}

final class LoremIpsumGeneratorViewModelTest: XCTestCase {

    func test_initiate_textFieldShouldEmpty() {
        let sut = LoremIpsumGeneratorViewModel()
        
        XCTAssertEqual(sut.inputText, "")
        XCTAssertEqual(sut.generatedText, "")
    }

}
