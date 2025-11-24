//
//  DevToModels.swift
//  TechBrief
//
//  Created by Maria on 24.11.2025.
//

import Foundation

struct DevToArticle: Decodable, Identifiable {
    let id: Int
    let title: String
    let url: String
    let readable_publish_date: String?
    let user: User

    struct User: Decodable {
        let username: String
    }
}
