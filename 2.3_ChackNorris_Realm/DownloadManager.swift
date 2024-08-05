//
//  DownloadManager.swift
//  2.3_ChackNorris_Realm
//
//  Created by Sergey on 31.07.2024.
//

import Foundation

struct JokeCodable: Codable {
    let id: String
    let value: String
    let categories: [String]
}

enum NetworkErrors: Error {
    case networkError
    case dataIsNil
    case parsingError
    case responseError
}

final class DownloadManager {
    
    static let shared = DownloadManager()
    
    func downloadJoke(
        categoryName: String?,
        completion: @escaping ((Result<JokeCodable, NetworkErrors>) -> Void)
    ) {
        var url: URL
        
        if let categoryName {
            url = URL(
                string: "https://api.chucknorris.io/jokes/random?category=\(categoryName)")!
        } else {
            url = URL(string: "https://api.chucknorris.io/jokes/random")!
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            if (response as? HTTPURLResponse)?.statusCode != 200 {
                completion(.failure(.responseError))
                return
            }
            
            guard let data else {
                completion(.failure(.dataIsNil))
                return
            }
            do {
                let joke = try JSONDecoder().decode(JokeCodable.self, from: data)
                completion(.success(joke))
            } catch {
                completion(.failure(.parsingError))
            }
            
        }.resume()
    }
}
