//
//  APIClient.swift
//  zaico_ios_codingtest
//
//  Created by ryo hirota on 2025/03/11.
//

import Foundation

protocol APIClientProtocol {
    func fetchInventories() async throws -> [Inventory]
    func fetchInventorie(id: Int?) async throws -> Inventory
    func addInventry(title: String) async throws
}

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    private let baseURL = "https://web.zaico.co.jp"
    private let token = "YOUR_ACCESS_TOKEN" // 実際のトークンに置き換える
    
    private init() {}

    func fetchInventories() async throws -> [Inventory] {
        let endpoint = "/api/v1/inventories"
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("[APIClient] API Response: \(jsonString)")
            }
            
            return try JSONDecoder().decode([Inventory].self, from: data)
        } catch {
            throw error
        }
    }
    
    func fetchInventorie(id: Int?) async throws -> Inventory {
        var endpoint = "/api/v1/inventories"
        
        if let id = id {
            endpoint += "/\(id)"
        }
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("[APIClient] API Response: \(jsonString)")
            }
            
            return try JSONDecoder().decode(Inventory.self, from: data)
        } catch {
            throw error
        }
    }
    
    func addInventry(title: String) async throws {
        let endpoint = "/api/v1/inventories"
        
        guard let url = URL(string: baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["title": title]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }
            }
        } catch {
            throw error
        }
    }
}
