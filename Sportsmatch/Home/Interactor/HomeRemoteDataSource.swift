//
//  HomeRemoteDataSource.swift
//  Sportsmatch
//
//  Created by Julio Figueiredo on 29/07/22.
//

import Foundation
import SwiftUI
import Combine

class HomeRemoteDataSource {
    static var shared: HomeRemoteDataSource = HomeRemoteDataSource()
    
    private init() {}
    
    func get() -> Future<Result, AppError> {
        return Future { promise in
            Service.call(path: .teste, httpMethod: .get) { result in
                switch result {
                case .failure(let error, let data):
                    if let data = data {
                        if error == .internalServerError {
                            let decoder = JSONDecoder()
                            let response = try? decoder.decode(ErrorResponse.self, from: data)
                            promise(.failure(AppError.response(message: response?.mensagem ?? "Servidor indisponível no momento. Tente mais tarde!")))
                        }
                        if error == .unauthorized {
                            let decoder = JSONDecoder()
                            let response = try? decoder.decode(ErrorResponse.self, from: data)
                            promise(.failure(AppError.response(message: response?.mensagem ?? "Não autorizado")))
                        }
                        if error == .notFound {
                            let decoder = JSONDecoder()
                            let response = try? decoder.decode(ErrorResponse.self, from: data)
                            promise(.failure(AppError.response(message: response?.mensagem ?? "Dados não encontrados")))
                        }
                    }
                    break
                case .success(let data):
                    let decoder = JSONDecoder()
                    let response = try? decoder.decode(Result.self, from: data)
                    guard let response = response else {
                        print("Log: Error parser \(String(data: data, encoding: .utf8) ?? "Erro ao gerar log")")
                        return
                    }
                    promise(.success(response))
                    break
                }
            }
        }
    }
}
