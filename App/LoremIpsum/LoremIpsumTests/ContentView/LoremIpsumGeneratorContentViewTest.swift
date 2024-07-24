//
//  LoremIpsumGeneratorContentViewTest.swift
//  LoremIpsumTests
//
//  Created by Albert Pangestu on 24/07/24.
//

import XCTest
import SwiftUI

struct LoremIpsumGeneratorContentView: View {
    var body: some View {
        EmptyView()
    }
}

final class LoremIpsumGeneratorContentViewTest: XCTestCase {

    func test_initialize_canBeInitialized() {
        let sut = LoremIpsumGeneratorContentView()
        
        XCTAssertNotNil(sut)
    }

}
