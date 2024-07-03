//
//  BubbleSortAnimationView.swift
//  Explorando Algoritmos
//
//  Created by Hugo Pinheiro  on 03/07/24.
//

import SwiftUI

struct BubbleSortAnimationView: View {
    @State private var numbers = [8, 3, 5, 1, 9, 2, 7, 4, 6]
    @State private var isSorting = false
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(0..<numbers.count, id: \.self) { index in
                    VStack {
                        Text("\(numbers[index])")
                            .foregroundColor(getTextColor())
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 30, height: CGFloat(numbers[index]) * 10)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            
            Button("Iniciar Ordenação") {
                isSorting = true
                bubbleSort()
            }
            .disabled(isSorting)
        }
        .navigationTitle("Ordenação por Bolha")
    }
    
    @Environment(\.colorScheme) var colorScheme
      
      func getTextColor() -> Color {
          return colorScheme == .dark ? .white : .black
      }
    
    func bubbleSort() {
        let n = numbers.count
        var swapped = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            while swapped {
                swapped = false
                for i in 1..<n {
                    if self.numbers[i-1] > self.numbers[i] {
                        DispatchQueue.main.async {
                            withAnimation {
                                self.numbers.swapAt(i-1, i)
                            }
                        }
                        swapped = true
                        usleep(500_000) // Pausa para visualização da troca
                    }
                }
            }
            DispatchQueue.main.async {
                self.isSorting = false
            }
        }
    }
}

#Preview {
    BubbleSortAnimationView()
}
