//
//  AlgorithmDetailViewModel.swift
//  Explorando Algoritmos
//
//  Created by Hugo Pinheiro  on 14/07/24.
//

import Foundation
import SwiftUI

class AlgorithmDetailViewModel: ObservableObject {
    
    @Published var algorithmName: String
    
    init(algorithmName: String) {
        self.algorithmName = algorithmName
    }
    
    func getAlgorithmDetailView() -> AnyView {
        switch algorithmName {
        case "Ordenação por Bolha":
            return AnyView(BubbleSortAnimationView())
        default:
            return AnyView(Text("Algoritmo desconhecido").padding())
        }
    }
}
