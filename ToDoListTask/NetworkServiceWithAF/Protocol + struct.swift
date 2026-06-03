//
//  Protocol + struct.swift
//  ToDoListTask
//
//  Created by Иван on 03.06.2026.
//

import Foundation

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

protocol ProtocolNetworkServiceAF {
    
    func getNewManagerData<T: Codable>(url: String) async throws -> T
}
