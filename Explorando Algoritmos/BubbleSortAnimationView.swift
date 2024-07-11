import SwiftUI

struct ActiveIndices: Equatable {
    let first: Int
    let second: Int
}

struct BubbleSortAnimationView: View {
    @State private var numbers = [8, 3, 5, 1, 9, 2, 7, 4, 6]
    @State private var isSorting = false
    @State private var activeIndices: ActiveIndices? = nil
    @State private var stepIndex = 0
    @State private var passIndex = 0
    @State private var isPaused = false
    @State private var sortingJob: DispatchWorkItem?

    private let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink, .gray, .brown
    ]

    var body: some View {
        VStack {
            Text("O algoritmo \"Bubble Sort\" é um método de ordenação simples que percorre a lista repetidamente, comparando elementos adjacentes e trocando-os se estiverem na ordem errada. Este processo é repetido até que a lista esteja ordenada.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(backgroundColor())
                    .frame(width: 400, height: 200) // Define o tamanho do quadrado fixo

                HStack(alignment: .bottom, spacing: 7) {
                    ForEach(Array(numbers.enumerated()), id: \.offset) { index, number in
                        VStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 33, height: max(CGFloat(number) * 10, 25))
                                .foregroundColor(colors[number % colors.count])
                                .overlay(
                                    Text("\(number)")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .bold))
                                        .padding(.bottom, 4), alignment: .bottom
                                )
                                .scaleEffect(activeIndices?.first == index || activeIndices?.second == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.5), value: activeIndices)

                            if activeIndices?.first == index || activeIndices?.second == index {
                                Color.black
                                    .frame(height: 3)
                                    .padding(.top, 2)
                                    .transition(.scale)
                                    .animation(.easeInOut(duration: 0.5), value: activeIndices)
                            } else {
                                Color.clear
                                    .frame(height: 3)
                                    .padding(.top, 2)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity) // Para garantir que o HStack use o máximo de largura disponível
            }

            Spacer()

            GeometryReader { geometry in
                let buttonWidth = (geometry.size.width - 60) / 3

                HStack(spacing: 20) {
                    Button(action: {
                        if isSorting {
                            isPaused.toggle()
                            if isPaused {
                                sortingJob?.cancel()
                                isSorting = false
                            } else {
                                isSorting = true
                                bubbleSort()
                            }
                        } else {
                            isSorting = true
                            isPaused = false
                            passIndex = 0
                            stepIndex = 0
                            bubbleSort()
                        }
                    }) {
                        HStack {
                            Image(systemName: isSorting && !isPaused ? "pause.circle" : "arrowtriangle.right.circle")
                                .font(.system(size: 25))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .frame(width: buttonWidth)
                        .background(RoundedRectangle(cornerRadius: 10).fill(isSorting && !isPaused ? Color.red : Color.blue))
                        .foregroundColor(.white)
                        .font(.headline)
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        stepSort()
                    }) {
                        HStack {
                            Image(systemName: "playpause.circle.fill")
                                .font(.system(size: 25))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .frame(width: buttonWidth)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.orange))
                        .foregroundColor(.white)
                        .font(.headline)
                    }
                    .disabled(isSorting)
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        shuffleNumbers()
                    }) {
                        HStack {
                            Image(systemName: "shuffle")
                                .font(.system(size: 25))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .frame(width: buttonWidth)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                        .foregroundColor(.white)
                        .font(.headline)
                    }
                    .disabled(isSorting)
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
            }
            .frame(height: 60) // Define a altura do GeometryReader para garantir que o layout funcione corretamente

            Spacer()
        }
    }

    @Environment(\.colorScheme) var colorScheme

    func getTextColor() -> Color {
        return colorScheme == .dark ? .white : .black
    }

    func backgroundColor() -> Color {
        return colorScheme == .dark ? Color(white: 0.2) : Color(white: 0.9)
    }

    func bubbleSort() {
        let n = numbers.count
        var swapped = true

        sortingJob = DispatchWorkItem {
            while swapped && !self.isPaused {
                swapped = false
                for i in 0..<(n - self.passIndex - 1) {
                    if self.isPaused || self.sortingJob?.isCancelled == true { return }
                    DispatchQueue.main.async {
                        self.activeIndices = ActiveIndices(first: i, second: i + 1)
                    }
                    if self.numbers[i] > self.numbers[i + 1] {
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                self.numbers.swapAt(i, i + 1)
                            }
                        }
                        swapped = true
                        usleep(500_000) // Pausa para visualização da troca
                    }
                    usleep(100_000) // Pausa para visualização dos elementos ativos
                }
                self.passIndex += 1
                if self.passIndex >= n - 1 {
                    self.isSorting = false
                    self.isPaused = false
                    self.activeIndices = nil
                    return
                }
            }
            DispatchQueue.main.async {
                self.isSorting = false
                self.activeIndices = nil
            }
        }

        if let sortingJob = sortingJob {
            DispatchQueue.global(qos: .userInitiated).async(execute: sortingJob)
        }
    }

    func stepSort() {
        let n = numbers.count
        if passIndex < n - 1 {
            if stepIndex < n - 1 - passIndex {
                DispatchQueue.main.async {
                    self.activeIndices = ActiveIndices(first: stepIndex, second: stepIndex + 1)
                }
                if numbers[stepIndex] > numbers[stepIndex + 1] {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        numbers.swapAt(stepIndex, stepIndex + 1)
                    }
                }
                stepIndex += 1
            } else {
                stepIndex = 0
                passIndex += 1
            }
        } else {
            stepIndex = 0
            passIndex = 0
            activeIndices = nil
        }
    }

    func shuffleNumbers() {
        numbers.shuffle()
        activeIndices = nil
        stepIndex = 0
        passIndex = 0
    }
}

#Preview {
    BubbleSortAnimationView()
}
