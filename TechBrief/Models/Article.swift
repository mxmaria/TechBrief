//
//  Article.swift
//  TechBrief
//
//  Created by Maria on 12.11.2025.
//

import Foundation

struct Article: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let url: URL?
}
