//
//  Rick_And_MortyApp.swift
//  Characters App
//
//  Created by Piotr Salari on 10/11/2024.
//

import SwiftUI

/// The main entry point of the Rick and Morty app.
/// This struct is responsible for setting up the main window and launching the app.
@main
struct Rick_And_MortyApp: App {
  // MARK: - Body
  
  var body: some Scene {
    /// The main window group of the app.
    WindowGroup {
      // The root view of the app is ContentView
      ContentView()
    }
  }
}
