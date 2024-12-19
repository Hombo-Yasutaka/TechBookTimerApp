//
//  APIClient.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2024/12/17.
//

import Foundation

final class APIClient {

    /// シングルトンインスタンス
    static let shared = APIClient()

    private init() {}

    /// GETリクエスト
    func getRequest(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }
}

