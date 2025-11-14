//
//  ArticleViewData.swift
//  TechBrief
//
//  Created by Maria on 14.11.2025.
//

import Foundation

struct ArticleViewData: Identifiable, Hashable {
    let id: String
    let title: String
    let source: String
    let timeAgo: String
    let url: URL?
}
