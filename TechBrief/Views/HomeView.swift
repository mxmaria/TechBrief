//
//  HomeView.swift
//  TechBrief
//
//  Created by Maria on 12.11.2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
                    List {
                        Text("Hello TechBrief")
                    }
                    .navigationTitle("TechBrief")
                }
    }
}

#Preview { HomeView() }
