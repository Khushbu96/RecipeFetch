//
//  NetworkError.swift
//  RecipeFetch
//
//  Created by Khushbu on 5/30/25.
//

enum NetworkError: Error {
    case invalidURL
    case invalidServerResponse
    case requestFailed
}
