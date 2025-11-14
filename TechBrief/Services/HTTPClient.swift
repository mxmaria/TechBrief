//
//  HTTPClient.swift
//  TechBrief
//
//  Created by Maria on 13.11.2025.
//

import Foundation

struct HTTPClient {
    func get<T: Decodable>(from url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                throw APIError.badStatus(code: httpResponse.statusCode)
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw APIError.decoding(underlying: error)
            }
        } catch {
            throw APIError.network(underlying: error)
        }
    }
}
