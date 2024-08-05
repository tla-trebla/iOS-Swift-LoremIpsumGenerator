//
//  ScrollableTextView.swift
//  LoremIpsum
//
//  Created by Albert Pangestu on 05/08/24.
//

import SwiftUI

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

#Preview {
    ScrollableTextView(text: "Lorem Ipsum Dolor Si Amet\nAnother Line") {
        print("I copy")
    }
}
