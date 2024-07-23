//
//  LoremIpsumGeneratorViewModel.swift
//  LoremIpsum
//
//  Created by Albert Pangestu on 23/07/24.
//

import UIKit
import LoremIpsumLib

final class LoremIpsumGeneratorViewModel: ObservableObject {
    @Published var generatedText: String = ""
    @Published var errorMessage: String?
    
    private let useCase: GenerateLoremIpsumUseCase
    
    init(useCase: GenerateLoremIpsumUseCase) {
        self.useCase = useCase
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
            case .none:
                errorMessage = "Error occured, please try again."
            }
            throw error
        }
    }
    
    func copyGeneratedText() {
        UIPasteboard.general.string = generatedText
    }
}
