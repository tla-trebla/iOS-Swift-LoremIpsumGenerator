//
//  LoremIpsumGeneratorViewModelTest.swift
//  LoremIpsumTests
//
//  Created by Albert Pangestu on 21/07/24.
//

@testable import LoremIpsum
import XCTest
import LoremIpsumLib

final class LoremIpsumGeneratorViewModelTest: XCTestCase {

    func test_initiate_generatedTextShouldEmpty() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.generatedText, "")
    }
    
    func test_initiate_useCaseShouldNotRequest() {
        let (_, useCase) = makeSUT()
        
        XCTAssertEqual(useCase.messages, [])
    }
    
    func test_generate_useCaseShouldRequest() async {
        let (sut, useCase) = makeSUT()
        
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(useCase.messages, [.generateText])
    }
    
    func test_generateMoreThanOne_useCaseShouldRequestMoreThanOne() async {
        let (sut, useCase) = makeSUT()
        
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        _ = try? await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        XCTAssertEqual(useCase.messages, [.generateText, .generateText])
    }
    
    func test_generateReceivedError_handleErrorMessage() async throws {
        let error = NSError(domain: "Whatever", code: 10)
        let (sut, _) = makeSUT(result: .failure(error))
        
        do {
            _ = try await sut.generateLoremIpsum(numberOfParagraphs: -1)
            XCTFail("Expected failure, a success is not an expectation")
        } catch {
            XCTAssertEqual(sut.errorMessage, "Error occured, please try again.")
        }
    }
    
    func test_generateReceivedGeneralErrors_handleEachGeneralErrorMessage() async throws {
        let expectedErrors: [GeneralError] = [.ErrorDecoding, .InvalidParameter, .NetworkError]
        
        for capturedError in expectedErrors {
            let (sut, _) = makeSUT(result: .failure(capturedError))
            
            do {
                _ = try await sut.generateLoremIpsum(numberOfParagraphs: -1)
                XCTFail("Expected an error, success is not an expectation")
            } catch {
                switch error as? GeneralError {
                case .ErrorDecoding:
                    XCTAssertEqual(sut.errorMessage, "Failed to decode the result. Please try again.")
                case .InvalidParameter:
                    XCTAssertEqual(sut.errorMessage, "Number of paragraphs should be more than 0.")
                case .NetworkError:
                    XCTAssertEqual(sut.errorMessage, "Network error, please try again.")
                case .none:
                    XCTAssertEqual(sut.errorMessage, "Error occured, please try again.")
                }
            }
        }
    }
    
    func test_generate_generatedTextShouldAvailable() async {
        let data = try! JSONFileLoader.load(fileName: "OneParagraphTextResponse")
        let textResponse = try! JSONDecoder().decode(TextResponse.self, from: data)
        let (sut, _) = makeSUT(result: .success(textResponse))
        
        do {
            _ = try await sut.generateLoremIpsum(numberOfParagraphs: 1)
        } catch {
            XCTFail("Should be success, any error is not an expectation.")
        }
        
        XCTAssertEqual(sut.errorMessage, nil)
        XCTAssertEqual(sut.generatedText, textResponse.text)
    }
    
    func test_copy_generatedTextCopied() async {
        let data = try! JSONFileLoader.load(fileName: "OneParagraphTextResponse")
        let textResponse = try! JSONDecoder().decode(TextResponse.self, from: data)
        let (sut, _) = makeSUT(result: .success(textResponse))
        _ = try! await sut.generateLoremIpsum(numberOfParagraphs: 1)
        
        sut.copyGeneratedText()
        
        XCTAssertEqual(sut.errorMessage, nil)
        XCTAssertEqual(UIPasteboard.general.string, textResponse.text)
    }
    
    // MARK: - Helper
    private func makeSUT(result: Result<TextResponse, Error>) -> (sut: LoremIpsumGeneratorViewModel, GenerateLoremIpsumUseCaseStub) {
        let useCase = GenerateLoremIpsumUseCaseStub(result: result)
        let sut = LoremIpsumGeneratorViewModel(useCase: useCase)
        
        return (sut, useCase)
    }
    
    private func makeSUT() -> (sut: LoremIpsumGeneratorViewModel, GenerateLoremIpsumUseCaseSpy) {
        let useCase = GenerateLoremIpsumUseCaseSpy()
        let sut = LoremIpsumGeneratorViewModel(useCase: useCase)
        
        return (sut, useCase)
    }
    
    final class GenerateLoremIpsumUseCaseSpy: GenerateLoremIpsumUseCase {
        private(set) var messages: [Message] = []
        
        func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
            messages.append(.generateText)
            let data = """
""".data(using: .utf8)!
            return try JSONDecoder().decode(TextResponse.self, from: data)
        }
        
        enum Message {
            case generateText
        }
    }
    
    final class GenerateLoremIpsumUseCaseStub: GenerateLoremIpsumUseCase {
        let result: Result<TextResponse, Error>
        
        init(result: Result<TextResponse, Error>) {
            self.result = result
        }
        
        func generateLoremIpsum(numberOfParagraphs: Int) async throws -> TextResponse {
            return try result.get()
        }
    }
    
    private enum JSONFileLoader {
        static func load(fileName: String) throws -> Data {
            guard let url = Bundle(for: LoremIpsumGeneratorViewModelTest.self).url(forResource: fileName, withExtension: "json") else {
                throw JSONFileLoaderError.FileNotFound
            }
            
            do {
                return try Data(contentsOf: url)
            } catch {
                throw JSONFileLoaderError.InvalidData
            }
        }
        
        enum JSONFileLoaderError: Swift.Error {
            case FileNotFound
            case InvalidData
        }
    }
}
