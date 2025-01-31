//
//  LoremIpsumApp.swift
//  LoremIpsum
//
//  Created by Albert Pangestu on 21/07/24.
//

import SwiftUI
import Domain

@main
struct LoremIpsumApp: App {
    var body: some Scene {
        WindowGroup {
            LoremIpsumGeneratorContentView(viewModel: LoremIpsumGeneratorViewModel(useCase: RemoteGenerateLoremIpsumUseCase(), clipboardService: UIKitClipboardService()))
        }
    }
}
