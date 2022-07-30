//
//  ErrorResponse.swift
//  Sportsmatch
//
//  Created by Julio Figueiredo on 29/07/22.
//

import Foundation

struct ErrorResponse: Decodable {
    let mensagem: String
    
    enum CodingKeys: String, CodingKey {
        case mensagem
    }
}
