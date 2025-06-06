//
//  ImageCacheManager.swift
//  RecipeFetch
//
//  Created by Khushbu on 6/2/25.
//

import Foundation
import SwiftUI

enum ImageCacheError: LocalizedError {
   case networkError(underlyingError: Error)
   case diskWriteError(underlyingError: Error)
   case diskReadError(underlyingError: Error)
   case imageDataCorrupted
   case couldNotCreateCacheDirectory(underlyingError: Error)
   case couldNotInitializeUIImage
   case cacheDirectoryURLNotFound
   case invalidIdentifierForFileURL
   case invalidServerResponse(statusCode: Int)
}

actor ImageCacheManager: ObservableObject {
   private let fileManager: FileManager
   private let cacheDirectory: URL
   private let urlSession: URLSession

   init(fileManager: FileManager = .default, urlSession: URLSession = .shared) throws {
       self.fileManager = fileManager
       self.urlSession = urlSession

       guard let systemCachesDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
           throw ImageCacheError.cacheDirectoryURLNotFound
       }
       self.cacheDirectory = systemCachesDirectory.appendingPathComponent("RecipeAppImageCache")

       guard !fileManager.fileExists(atPath: cacheDirectory.pathExtension) else {
           return
       }
       do {
           try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
       } catch {
           throw ImageCacheError.couldNotCreateCacheDirectory(underlyingError: error)
       }
   }

    func cacheFileURL(for identifier: String) throws -> URL {
       guard !identifier.isEmpty, !identifier.contains("/"), !identifier.contains(":") else {
           throw ImageCacheError.invalidIdentifierForFileURL
       }
       return cacheDirectory.appendingPathComponent(identifier)
   }

   func loadImage(from url: URL, identifier: String) async throws -> UIImage {
       let targetFileURL = try cacheFileURL(for: identifier)
       if fileManager.fileExists(atPath: targetFileURL.path) {
           do {
               let imageData = try Data(contentsOf: targetFileURL)
               if let image = UIImage(data: imageData) {
                   return image
               } else {
                   try? fileManager.removeItem(at: targetFileURL)
                   throw ImageCacheError.imageDataCorrupted
               }
           } catch {
               throw ImageCacheError.diskReadError(underlyingError: error)
           }
       }

       let (data, _) = try await urlSession.data(from: url)

       guard let image = UIImage(data: data) else {
           throw ImageCacheError.couldNotInitializeUIImage
       }

       do {
           try data.write(to: targetFileURL, options: .atomic)
       } catch {
           throw ImageCacheError.diskWriteError(underlyingError: error)
       }

       return image
   }

   func clearCache() throws {
       do {
           let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil, options: [])
           for fileURL in contents {
               try fileManager.removeItem(at: fileURL)
           }
       } catch {
           throw ImageCacheError.diskWriteError(underlyingError: error)
       }
   }
}
