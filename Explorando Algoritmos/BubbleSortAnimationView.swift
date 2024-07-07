//
//  BubbleSortAnimationView.swift
//  Explorando Algoritmos
//
//  Created by Hugo Pinheiro  on 03/07/24.
//

import SwiftUI

struct ActiveIndices: Equatable {
    let first: Int
    let second: Int
}

struct BubbleSortAnimationView: View {
    @State private var numbers = [8, 3, 5, 1, 9, 2, 7, 4, 6]
    @State private var isSorting = false
    @State private var stepIndex = 0
    @State private var activeIndices: ActiveIndices? = nil
    
    private let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink, .gray, .brown
    ]
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(0..<numbers.count, id: \.self) { index in
                    VStack {
                        Text("\(numbers[index])")
                            .foregroundColor(getTextColor())
                            .offset(y: activeIndices?.first == index || activeIndices?.second == index ? -10 : 0)
                            .animation(.easeInOut(duration: 0.3).repeatCount(activeIndices != nil ? 3 : 0, autoreverses: true), value: activeIndices)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 30, height: CGFloat(numbers[index]) * 10)
                            .foregroundColor(activeIndices?.first == index || activeIndices?.second == index ? .red : colors[index % colors.count])
                            .scaleEffect(activeIndices?.first == index || activeIndices?.second == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.5), value: activeIndices)
                        
                        if activeIndices?.first == index || activeIndices?.second == index {
                            Image(systemName: "arrow.down")
                                .foregroundColor(.blue)
                                .transition(.scale)
                                .animation(.easeInOut(duration: 0.5), value: activeIndices)
                        } else {
                            Spacer().frame(height: 16)
                        }
                    }
                }
            }
            .padding()
            
            HStack(spacing: 20) {
                Button(action: {
                    isSorting = true
                    bubbleSort()
                }) {
                    Text("Iniciar Ordenação")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        .foregroundColor(getTextColor())
                        .font(.headline)
                }
                .disabled(isSorting)
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    stepSort()
                }) {
                    Text("Ordenar Passo a Passo")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                        .foregroundColor(getTextColor())
                        .font(.headline)
                }
                .disabled(isSorting)
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
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
                for i in stride(from: n-1, to: 0, by: -1) {
                    DispatchQueue.main.async {
                        self.activeIndices = ActiveIndices(first: i-1, second: i)
                    }
                    if self.numbers[i-1] > self.numbers[i] {
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.numbers.swapAt(i-1, i)
                            }
                        }
                        swapped = true
                        usleep(500_000) // Pausa para visualização da troca
                    }
                    usleep(100_000) // Pausa para visualização dos elementos ativos
                }
            }
            DispatchQueue.main.async {
                self.isSorting = false
                self.activeIndices = nil
            }
        }
    }
    
    func stepSort() {
        let n = numbers.count
        if stepIndex < n - 1 {
            let currentIndex = n - 1 - stepIndex
            DispatchQueue.main.async {
                self.activeIndices = ActiveIndices(first: currentIndex - 1, second: currentIndex)
            }
            if numbers[currentIndex - 1] > numbers[currentIndex] {
                withAnimation(.easeInOut(duration: 0.5)) {
                    numbers.swapAt(currentIndex - 1, currentIndex)
                }
            }
            stepIndex += 1
        } else {
            stepIndex = 0
            activeIndices = nil
        }
    }
}

#Preview {
    BubbleSortAnimationView()
}
