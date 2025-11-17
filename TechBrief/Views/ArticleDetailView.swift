//
//  ArticleDetailView.swift
//  TechBrief
//
//  Created by Maria on 17.11.2025.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: ArticleViewData
    @State private var showWebView = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(article.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 8) {
                    Text(article.source)
                    Text("•")
                    Text(article.timeAgo)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                if let url = article.url {
                    Text(url.host ?? url.absoluteString)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }

                Spacer(minLength: 24)

                if article.url != nil {
                    Button {
                        showWebView = true
                    } label: {
                        Label("Open in Browser", systemImage: "safari")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Text("No link available for this article.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showWebView) {
            if let url = article.url {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
    }
}
