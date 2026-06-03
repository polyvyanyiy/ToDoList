//
//  ViewModelService.swift
//  ToDoListTask
//
//  Created by Иван on 03.06.2026.
//

import Foundation

@MainActor
class ViewModelServiceAA {
    
    // объявляем протокол сервиса
    private let protocolModel: ProtocolNetworkServiceAF
    
    var newDate: ToDoList? = nil
    
    init(protocolModel: ProtocolNetworkServiceAF) {
        self.protocolModel = protocolModel
    }
    
    private func createURL() -> String? {
        let tunnel = "https://"
        let server = "dummyjson.com"
        let endpoint = EndPoint.todos
        let getParams = ""
        let url = tunnel + server + endpoint.rawValue + getParams
        return url
    }
    
    func loadData() async throws {
        guard let url = createURL() else {
            throw NetworkError.badURL
        }
        
        do {
            let resultData: ToDoList = try await protocolModel.getNewManagerData(url: url)
            self.newDate = resultData
        } catch {
            print("\(NetworkError.badRequest) Ошибка загрузки: \(error.localizedDescription)")
        }
    }
}
