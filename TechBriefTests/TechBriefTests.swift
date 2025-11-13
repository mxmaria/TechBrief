//
//  TechBriefTests.swift
//  TechBriefTests
//
//  Created by Maria on 12.11.2025.
//

import XCTest
@testable import TechBrief

final class HTTPClientTests: XCTestCase {

    func testDecodingSampleArticle() throws {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "sample_article", withExtension: "json")
        XCTAssertNotNil(url, "Fixture file not found")

        let data = try Data(contentsOf: try XCTUnwrap(url))

        let decoder = JSONDecoder()
        let article = try decoder.decode(SampleArticle.self, from: data)

        XCTAssertEqual(article.title, "Test Article")
        XCTAssertEqual(article.url, "https://example.com")
    }
}
