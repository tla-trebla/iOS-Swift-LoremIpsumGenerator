//
//  LoremIpsumGeneratorContentView.swift
//  LoremIpsum
//
//  Created by Albert Pangestu on 26/07/24.
//

import SwiftUI
import Domain

struct LoremIpsumGeneratorContentView: View {
    @StateObject var viewModel: LoremIpsumGeneratorViewModel
    @State private var numberOfParagraphs: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Number of Paragraphs", text: $numberOfParagraphs)
                    .keyboardType(.numberPad)
                    .onChange(of: numberOfParagraphs) { _, newValue in
                        numberOfParagraphs = newValue.filter({ "0123456789".contains($0) })
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button(action: {
                    Task {
                        try await viewModel.generateLoremIpsum(numberOfParagraphs: Int(numberOfParagraphs)!)
                    }
                }, label: {
                    Text("Generate")
                }).padding()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
                
                Text(viewModel.generatedText)
                    .onLongPressGesture {
                        viewModel.copyGeneratedText()
                    }.padding()
            }
        }
    }
}

#Preview {
    LoremIpsumGeneratorContentView(viewModel: LoremIpsumGeneratorViewModel(useCase: RemoteGenerateLoremIpsumUseCase(), clipboardService: UIKitClipboardService()))
}
