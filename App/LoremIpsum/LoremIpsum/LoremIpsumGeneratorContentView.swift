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
    @State private var keyboardHeight: CGFloat = 0
    @State private var numberOfParagraphs: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollableTextView(text: viewModel.generatedText,
                                   onLongPress: {
                    viewModel.copyGeneratedText()
                })
                .frame(maxHeight: geometry.size.height * 0.6)
                
                Spacer()
                
                VStack {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .padding()
                    }
                    
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
                }
                .padding()
                .padding(.bottom, keyboardHeight)
                .animation(.easeOut, value: 0.3)
            }
            .onAppear(perform: subscribeToKeyboardEvents)
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    private func subscribeToKeyboardEvents() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            keyboardHeight = 0
        }
    }
}

#Preview {
    LoremIpsumGeneratorContentView(viewModel: LoremIpsumGeneratorViewModel(useCase: RemoteGenerateLoremIpsumUseCase(), clipboardService: UIKitClipboardService()))
}

struct ScrollableTextView: UIViewRepresentable {
    var text: String
    var onLongPress: () -> Void
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: ScrollableTextView
        
        init(parent: ScrollableTextView) {
            self.parent = parent
        }
        
        @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                parent.onLongPress()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let scrollView = UIScrollView()
        let textView = UILabel()
        
        textView.text = text
        textView.numberOfLines = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            textView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            textView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPressGesture(_:)))
        longPressGesture.delegate = context.coordinator
        scrollView.addGestureRecognizer(longPressGesture)
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if let textView = uiView.subviews.first as? UILabel {
            textView.text = text
        }
    }
}
