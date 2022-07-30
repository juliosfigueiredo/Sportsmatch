//
//  HomeViewModel.swift
//  Sportsmatch
//
//  Created by Julio Figueiredo on 29/07/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var uiState: HomeUIState = .loading
    
    @Published var img = String()
    @Published var name = String()
    @Published var percentual = String()
    @Published var pos = String()
    @Published var country = String()
    @Published var maxCopaVencidas = 3.0
    @Published var plaCopaVencidas = 3.0
    @Published var posCopaVencidas = 10
    @Published var maxCopaDisputadas = 3.0
    @Published var plaCopaDisputadas = 3.0
    @Published var posCopaDisputadas = 10
    
    private var cancellableRequest: AnyCancellable?
    
    private let interactor: HomeInteractor
    
    init(interactor: HomeInteractor) {
        self.interactor = interactor
    }
    
    deinit {
        cancellableRequest?.cancel()
    }
    
    func onApper() {
        self.uiState = .loading
        cancellableRequest = interactor.get()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch (completion) {
                case .failure(let appError):
                    self.uiState = .error(appError.message)
                    break
                case .finished:
                    break
                }
            }, receiveValue: { dados in
                if dados.object.isEmpty {
                    self.uiState = .empty
                } else {
                    self.uiState = .full
                    
                    let player = dados.object[0].player
                    self.img = player.img
                    self.name = player.name
                    self.percentual = String(format:"%.3f", player.percentual)
                    self.pos = player.pos
                    self.country = player.country
                    self.maxCopaVencidas = player.barras.copasVencidas.max
                    self.plaCopaVencidas = player.barras.copasVencidas.pla
                    
                    self.posCopaVencidas = player.barras.copasVencidas.pos
                    
                    self.maxCopaDisputadas = player.barras.copasDisputadas.max
                    
                    self.plaCopaDisputadas = player.barras.copasDisputadas.pla
                    
                    self.posCopaDisputadas = player.barras.copasDisputadas.pos
                }
            })
    }
}

extension String {
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}
