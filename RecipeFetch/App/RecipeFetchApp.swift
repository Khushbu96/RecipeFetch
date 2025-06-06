//
//  RecipeFetchApp.swift
//  RecipeFetch
//
//  Created by Khushbu on 5/30/25.
//

import SwiftUI

@main
struct RecipeFetchApp: App {
    @StateObject private var imageCacheManager = try! ImageCacheManager()

    var body: some Scene {
        WindowGroup {
            RecipesList()
                .environmentObject(imageCacheManager)
        }
    }
}
