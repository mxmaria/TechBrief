//
//  TechBriefApp.swift
//  TechBrief
//
//  Created by Maria on 12.11.2025.
//

import SwiftUI

@main
struct TechBriefApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                SavedView()
                    .tabItem {
                        Label("Saved", systemImage: "star")
                    }
            }
        }
    }
}
