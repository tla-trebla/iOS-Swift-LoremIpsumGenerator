//
//  LoremIpsumGeneratorViewModel.swift
//  LoremIpsum
//
//  Created by Albert Pangestu on 23/07/24.
//

import UIKit
import Domain

@MainActor
final class LoremIpsumGeneratorViewModel: ObservableObject {
    @Published var generatedText: String = ""
    @Published var errorMessage: String?
    
    private let useCase: GenerateLoremIpsumUseCase
    private let clipboardService: ClipboardService
    
    init(useCase: GenerateLoremIpsumUseCase, clipboardService: ClipboardService) {
        self.useCase = useCase
        self.clipboardService = clipboardService
    }
    
    func generateLoremIpsum(numberOfParagraphs: Int) async throws {
        do {
            let response = try await useCase.generateLoremIpsum(numberOfParagraphs: numberOfParagraphs)
            generatedText = response.text
        } catch {
            switch error as? GeneralError {
            case .ErrorDecoding:
                errorMessage = "Failed to decode the result. Please try again."
            case .InvalidParameter:
                errorMessage = "Number of paragraphs should be more than 0."
            case .NetworkError:
                errorMessage = "Network error, please try again."
            case .InvalidURL:
                errorMessage = "Invalid URL. Please contact to the developer."
            case .none:
                errorMessage = "Error occured, please try again."
            }
            throw error
        }
    }
    
    func copyGeneratedText() {
        guard generatedText != "" else { return }
        clipboardService.copy(generatedText)
    }
}

protocol ClipboardService {
    func copy(_ text: String)
}

final class UIKitClipboardService: ClipboardService {
    func copy(_ text: String) {
        UIPasteboard.general.string = text
    }
}
