//
//  ArticleRowView.swift
//  TechBrief
//
//  Created by Maria on 17.11.2025.
//

import SwiftUI

struct ArticleRowView: View {
    let article: ArticleViewData
    let onToggleSave: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            Button(action: onToggleSave) {
                Image(systemName: article.isSaved ? "star.fill" : "star")
                    .font(.system(size: 18))
                    .foregroundStyle(article.isSaved ? .yellow : .secondary)
                    .padding(6)
            }
            .buttonStyle(.borderless)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(article.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
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
        .padding(.vertical, 8)
    }
}
    
    
#Preview {
    ArticleRowView(
        article: ArticleViewData(
        id: "1",
        title: "Example article title that is a bit longer",
        source: "Hacker News",
        timeAgo: "3h",
        url: URL(string: "https://example.com"),
        isSaved: false
        ),
    onToggleSave: {}
    )
    .padding()
}
