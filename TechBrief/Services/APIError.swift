//
//  APIError.swift
//  TechBrief
//
//  Created by Maria on 13.11.2025.
//

import Foundation

enum APIError: Error {
    case network(underlying: Error)
    case badStatus(code: Int)
    case decoding(underlying: Error)
    case unknown
}
