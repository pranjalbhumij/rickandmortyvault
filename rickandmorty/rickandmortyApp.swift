//
//  rickandmortyApp.swift
//  rickandmorty
//
//  Created by Baba Yaga on 26/12/24.
//

import SwiftUI

@main
struct rickandmortyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: RMViewModel())
        }
    }
}
