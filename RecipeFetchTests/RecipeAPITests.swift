//
//  RecipeAPITests.swift
//  RecipeFetchTests
//
//  Created by Khushbu on 6/4/25.
//

import Testing
import Foundation
@testable import RecipeFetch

@Suite(.serialized)
struct RecipeAPITests {
    var session: URLSession
    var networkManager: NetworkManager
    var recipeAPI: RecipeAPI

    init() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        self.session = URLSession(configuration: config)
        self.networkManager = NetworkManager(session: session)
        self.recipeAPI = RecipeAPI(networkManager: networkManager, baseURL: "https://example.com")
    }

    private func configureMockResponse(
            data: Data?,
            statusCode: Int = 200,
            error: Error? = nil
        ) {
            MockURLProtocol.reset()
            MockURLProtocol.stubData = data
            MockURLProtocol.stubResponse = HTTPURLResponse(
                url: URL(string: "https://example.com")!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )
            MockURLProtocol.stubError = error
        }

    @Test func fetchRecipesSuccessfully() async throws {
        // Arrange
        let jsonData = """
        {
            "recipes": [
                {
                    "cuisine": "Malaysian",
                    "name": "Apam Balik",
                    "photo_url_large": "https://example.com/large.jpg",
                    "photo_url_small": "https://example.com/small.jpg",
                    "source_url": "https://example.com/recipe",
                    "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
                    "youtube_url": "https://www.youtube.com/watch?v=example"
                }
            ]
        }
        """.data(using: .utf8)!
        configureMockResponse(data: jsonData)

        let recipes = try await recipeAPI.fetchRecipeList()

        #expect(recipes.count == 1)
        #expect(recipes.first?.name == "Apam Balik")
    }

    @Test func handleDecodingFailure() async throws {
        let invalidJson = """
        {
            "invalid_key": []
        }
        """.data(using: .utf8)!
        configureMockResponse(data: invalidJson)

        do {
            _ = try await recipeAPI.fetchRecipeList()
            #expect(Bool(false), "Expected decoding failure")
        } catch let error as NetworkError {
            #expect(error == .requestFailed)
        }
    }

    @Test func handleInvalidServerResponse() async throws {
        let jsonData = "{}".data(using: .utf8)!
        configureMockResponse(data: jsonData, statusCode: 500)

        do {
            _ = try await recipeAPI.fetchRecipeList()
            #expect(Bool(false), "Expected invalid server response")
        } catch let error as NetworkError {
            #expect(error == .invalidServerResponse)
        }
    }
}
