//
//  NetworkManager.swift
//  RecipeFetch
//
//  Created by Khushbu on 5/30/25.
//

import Foundation

actor NetworkManager {
    
    static let shared = NetworkManager()
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func makeRequest<T: Codable>(type: T.Type, urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              200...299 ~= response.statusCode else {
            throw NetworkError.invalidServerResponse
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.requestFailed
        }
    }
}

