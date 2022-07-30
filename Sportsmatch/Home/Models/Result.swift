//
//  Result.swift
//  Sportsmatch
//
//  Created by Julio Figueiredo on 29/07/22.
//

import Foundation

// MARK: - Result
struct Result: Codable, Equatable {
    static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.status == rhs.status
    }
    
    let status: Int
    let object: [Object]

    enum CodingKeys: String, CodingKey {
        case status = "Status"
        case object = "Object"
    }
}

// MARK: - Object
struct Object: Codable {
    let player: Player

    enum CodingKeys: String, CodingKey {
        case player = "Player"
    }
}

// MARK: - Player
struct Player: Codable {
    let img: String
    let name: String
    let percentual: Double
    let pos, country: String
    let barras: Barras

    enum CodingKeys: String, CodingKey {
        case img, name, percentual, pos, country
        case barras = "Barras"
    }
}

// MARK: - Barras
struct Barras: Codable {
    let copasVencidas, copasDisputadas: Copas

    enum CodingKeys: String, CodingKey {
        case copasVencidas = "Copas_do_Mundo_Vencidas"
        case copasDisputadas = "Copas_do_Mundo_Disputadas"
    }
}

// MARK: - Copas
struct Copas: Codable {
    let max: Double
    let pla: Double
    let pos: Int
}
