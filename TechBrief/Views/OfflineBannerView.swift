//
//  OfflineBannerView.swift
//  TechBrief
//
//  Created by Maria on 28.11.2025.
//

import SwiftUI

struct OfflineBannerView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
            Text("Offline: showing last cached articles")
        }
        .font(.subheadline)
        .foregroundColor(.orange)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.12))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top, 4)
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

#Preview {
    OfflineBannerView()
}
