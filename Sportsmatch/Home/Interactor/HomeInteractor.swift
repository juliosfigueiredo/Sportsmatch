//
//  HomeInteractor.swift
//  Sportsmatch
//
//  Created by Julio Figueiredo on 29/07/22.
//

import Foundation
import Combine

class HomeInteractor {
    private let remote: HomeRemoteDataSource = .shared
}

extension HomeInteractor {
    func get() -> Future<Result, AppError> {
        return remote.get()
    }
}
