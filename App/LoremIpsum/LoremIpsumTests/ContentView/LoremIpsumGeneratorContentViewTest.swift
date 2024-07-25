//
//  LoremIpsumGeneratorContentViewTest.swift
//  LoremIpsumTests
//
//  Created by Albert Pangestu on 24/07/24.
//

@testable import LoremIpsum
import XCTest
import LoremIpsumLib
import SwiftUI

struct LoremIpsumGeneratorContentView: View {
    @StateObject var viewModel: LoremIpsumGeneratorViewModel
    
    var body: some View {
        EmptyView()
    }
}

final class LoremIpsumGeneratorContentViewTest: XCTestCase {

    func test_initialize_canBeInitialized() {
        let useCase = GenerateLoremIpsumUseCaseDummy()
        let service = ClipboardServiceDummy()
        let viewModel = LoremIpsumGeneratorViewModel(useCase: useCase, clipboardService: service)
        let sut = LoremIpsumGeneratorContentView(viewModel: viewModel)
        
        XCTAssertNotNil(sut)
    }
    
    // MARK: - Helpers
    final class GenerateLoremIpsumUseCaseDummy: GenerateLoremIpsumUseCase {
        func generateLoremIpsum(numberOfParagraphs: Int) async throws -> LoremIpsumLib.TextResponse {
            let data = """
""".data(using: .utf8)!
            return try JSONDecoder().decode(TextResponse.self, from: data)
        }
    }
    
    final class ClipboardServiceDummy: ClipboardService {
        func copy(_ text: String) { }
    }

}
