//
//  HomeUIState.swift
//  Sportsmatch
//
//  Created by Julio Figueiredo on 29/07/22.
//

import Foundation

enum HomeUIState: Equatable {
    case loading
    case empty
    case full
    case error(String)
}
