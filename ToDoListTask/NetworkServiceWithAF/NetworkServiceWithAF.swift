//
//  NetworkServiceWithAF.swift
//  ToDoListTask
//
//  Created by Иван on 25.05.2026.
//

import Foundation
import Alamofire

enum EndPoint: String {
    case todos = "/todos"
}

enum NetworkError: Error {
    case badURL
    case badRequest
    case badResponse
    case invalidEncoding
    case invalidDecoding
    case badServerResponse
}

struct ToDoList: Codable {
    let todos: [ToDo]
    
    struct ToDo: Codable {
        var id: Int
        var todo: String
        var completed: Bool
        var userId: Int
    }
}

final class NetworkServiceWithAF {
    
    static let shared = NetworkServiceWithAF(); private init() {}
    
    private func createURL() -> String {
        let tunnel = "https://"
        let server = "dummyjson.com"
        let endpoint = EndPoint.todos
        let getParams = ""
        let url = tunnel + server + endpoint.rawValue + getParams
        return url
    }
    
    func fetchData(completion: @escaping (Result<ToDoList, Error>) -> ()) {
        AF.request(createURL()).validate().response { response in
            guard let data = response.data else {
                if let error = response.error {
                    completion(.failure(error))
                } else {
                    completion(.failure(NetworkError.badResponse))
                }
                return
            }
            
            let decoder = JSONDecoder()
            // decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            DispatchQueue.main.async {
                guard let toDoList = try? decoder.decode(ToDoList.self, from: data) else {
                    completion(.failure(NetworkError.invalidDecoding))
                    return
                }
                
                completion(.success(toDoList))
            }
        }
    }
}
