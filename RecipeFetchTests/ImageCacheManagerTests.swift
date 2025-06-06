//
//  ImageCacheManagerTests.swift
//  RecipeFetchTests
//
//  Created by Khushbu on 6/4/25.
//

import Testing
@testable import RecipeFetch
import Foundation
import UIKit

@Suite(.serialized)
struct ImageCacheManagerTests {
    var tempDirectory: URL!
    var fileManager: FileManager!
    var urlSession: URLSession!
    var imageCacheManager: ImageCacheManager!

    mutating func setUp() async throws {
        MockURLProtocol.reset()
        fileManager = FileManager.default
        tempDirectory = fileManager.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try fileManager.createDirectory(at: tempDirectory, withIntermediateDirectories: true)

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)

        imageCacheManager = try ImageCacheManager(fileManager: fileManager, urlSession: urlSession)
    }
    
    func createDummyImage(size: CGSize = CGSize(width: 20, height: 20)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        UIColor.red.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    @Test mutating func testLoadImageFromNetworkAndCache() async throws {
        try await setUp()

        let dummyImage = createDummyImage()
        let dummyData = dummyImage.pngData()!
        let url = URL(string: "https://example.com/image.png")!
        let identifier = "image.png"

        MockURLProtocol.stubData = dummyData
        MockURLProtocol.stubResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        let image = try await imageCacheManager.loadImage(from: url, identifier: identifier)
        #expect(image.size == dummyImage.size, "Expected image to match dummy image size")

        let cachedImage = try await imageCacheManager.loadImage(from: url, identifier: identifier)
        #expect(cachedImage.size == dummyImage.size, "Expected cached image to match dummy image size")
    }

    @Test mutating func testLoadImageWithInvalidIdentifier() async throws {
        try await setUp()

        let url = URL(string: "https://example.com/image.png")!
        do {
            _ = try await imageCacheManager.loadImage(from: url, identifier: "/invalid:path")
            #expect(Bool(false), "Expected invalid identifier error")
        } catch let error as ImageCacheError {
            if case .invalidIdentifierForFileURL = error {
                #expect(true)
            } else {
                #expect(Bool(false), "Expected .invalidIdentifierForFileURL")
            }
        }
    }

    @Test mutating func testClearCacheDeletesFiles() async throws {
        try await setUp()

        let dummyImage = createDummyImage()
        let dummyData = dummyImage.pngData()!
        let url = URL(string: "https://example.com/image.png")!
        let identifier = "image.png"

        MockURLProtocol.stubData = dummyData
        MockURLProtocol.stubResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)

        _ = try await imageCacheManager.loadImage(from: url, identifier: identifier)

        try await imageCacheManager.clearCache()

        let targetURL = try await imageCacheManager.cacheFileURL(for: identifier)
        let exists = fileManager.fileExists(atPath: targetURL.path)
        #expect(exists == false, "Expected file to be deleted after clearCache")
    }
}
