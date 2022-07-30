//
//  SportsmatchApp.swift
//  Sportsmatch
//
//  Created by Julio Figueiredo on 29/07/22.
//

import SwiftUI

@main
struct SportsmatchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: HomeViewModel(interactor: HomeInteractor()))
        }
    }
}
