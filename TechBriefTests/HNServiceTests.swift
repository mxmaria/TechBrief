//
//  HNServiceTests.swift
//  TechBrief
//
//  Created by Maria on 2.12.2025.
//

import XCTest
@testable import TechBrief

final class HNServiceTests: XCTestCase {

    private func loadJSON(named name: String) throws -> Data {
        let bundle = Bundle(for: HNServiceTests.self)
        guard let url = bundle.url(forResource: name, withExtension: "json") else {
            XCTFail("Missing fixture \(name).json")
            throw NSError(domain: "Fixture", code: 0)
        }
        return try Data(contentsOf: url)
    }

    func testHNResponseDecodesFromFixture() throws {
        let data = try loadJSON(named: "topArticles")

        let response = try JSONDecoder().decode(HNResponse.self, from: data)

        XCTAssertEqual(response.hits.count, 1)
        XCTAssertEqual(response.hits.first?.title, "Test Title")
        XCTAssertEqual(response.hits.first?.author, "john")
    }

    func testArticleMappingToViewData() {
        let article = HNArticle(
            id: "1",
            title: "Hello",
            url: "https://example.com",
            author: "abc",
            createdAt: "1704100800"
        )

        let viewData = article.toViewData()

        XCTAssertEqual(viewData.id, "1")
        XCTAssertEqual(viewData.title, "Hello")
        XCTAssertEqual(viewData.source, "Hacker News")
    }
}
