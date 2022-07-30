//
//  ContentView.swift
//  Sportsmatch
//
//  Created by Julio Figueiredo on 29/07/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State var valorCopasAtual = 5.0
    
    var body: some View {
        ZStack {
            Color.blue
            if case HomeUIState.loading = viewModel.uiState {
                ProgressView()
            } else if case HomeUIState.empty = viewModel.uiState {
                Text("Dados não localizados")
            } else if case HomeUIState.error(let error) = viewModel.uiState {
                Text("\(error)")
            } else if case HomeUIState.full = viewModel.uiState {
                VStack {
                    
                    AvatarView(url: viewModel.img)
                        .frame(width: 150, height: 150)
                        .background(Color.gray)
                        .clipShape(Circle())
                    
                    Text(viewModel.name)
                        .font(.title)
                        .padding(2)
                        .foregroundColor(Color.white)
                    
                    Text(viewModel.country)
                        .font(.title3)
                        .padding(2)
                        .foregroundColor(Color.white)
                    
                    Text(viewModel.pos)
                        .font(.title3)
                        .padding(2)
                        .foregroundColor(Color.white)

                    Text("\(viewModel.percentual)")
                        .frame(width: 100, height: 100, alignment: .center)
                        .font(.title3)
                        .padding(2)
                        .foregroundColor(Color.white)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .padding(6)
                            )
                    
                    VStack {
                        VStack {
                            ProgressView("Copas do mundo vencidas", value: viewModel.plaCopaVencidas, total: viewModel.maxCopaVencidas)
                                .accentColor(Color.white)
                                .foregroundColor(Color.white)
                            
                            HStack {
                                Text("\(String(format:"%.1f", viewModel.plaCopaVencidas))")
                                    .foregroundColor(Color.white)
                                
                                Spacer()
                                
                                Text("\(viewModel.posCopaVencidas)º")
                                    .foregroundColor(Color.white)
                            }
                        }
                        .padding()
                        
                        VStack {
                            ProgressView("Copas do mundo disputadas", value: viewModel.plaCopaDisputadas, total: viewModel.maxCopaDisputadas)
                                .accentColor(Color.white)
                                .foregroundColor(Color.white)
                            HStack {
                                Text("\(String(format:"%.1f", viewModel.plaCopaDisputadas))")
                                    .foregroundColor(Color.white)
                                
                                Spacer()
                                
                                Text("\(viewModel.posCopaDisputadas)º")
                                    .foregroundColor(Color.white)
                            }
                        }
                        .padding()
                    }
                    .padding()
                    
                        
                }
                .padding()
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            viewModel.onApper()
        }
    }
}

struct AvatarView: View {
    let url: String

    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 150, height: 150)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: HomeViewModel(interactor: HomeInteractor()))
    }
}
