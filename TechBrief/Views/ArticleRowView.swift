//
//  ArticleRowView.swift
//  TechBrief
//
//  Created by Maria on 17.11.2025.
//

import SwiftUI

struct ArticleRowView: View {
    let article: ArticleViewData

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)

                HStack(spacing: 6) {
                    Text(article.source)
                    Text("•")
                    Text(article.timeAgo)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    ArticleRowView(
        article: ArticleViewData(
            id: "1",
            title: "Example article title that is a bit longer",
            source: "Hacker News",
            timeAgo: "3h",
            url: URL(string: "https://example.com")
        )
    )
    .padding()
}
