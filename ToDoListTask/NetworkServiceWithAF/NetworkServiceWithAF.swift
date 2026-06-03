//
//  NetworkServiceWithAF.swift
//  ToDoListTask
//
//  Created by Иван on 25.05.2026.
//

import Foundation
import Alamofire


final class NetworkServiceWithAF: ProtocolNetworkServiceAF {
    // ушли от синглтона
    init() {}
    
    func getNewManagerData<T: Codable>(url: String) async throws -> T {
        let value = try await AF.request(url)
            .validate()
            .serializingDecodable(T.self)
            .value
        
        return value
    }
}
