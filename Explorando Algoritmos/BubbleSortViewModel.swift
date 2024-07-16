import SwiftUI

struct ActiveIndices: Equatable {
    let first: Int
    let second: Int
}

class BubbleSortViewModel: ObservableObject {
    @Published var numbers = [8, 3, 5, 1, 9, 2, 7, 4, 6]
    @Published var isSorting = false
    @Published var activeIndices: ActiveIndices? = nil
    @Published var stepIndex = 0
    @Published var passIndex = 0
    @Published var isPaused = false
    @Published var showComplexityText = false
    var sortingJob: DispatchWorkItem?

    private let colors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple, .pink, .gray, .brown
    ]

    func backgroundColor() -> Color {
        return Color(white: 0.9)
    }

    func getColor(for number: Int) -> Color {
        return colors[number % colors.count]
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
                    DispatchQueue.main.async {
                        self.showComplexityText = true
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                self.isSorting = false
                self.activeIndices = nil
                self.showComplexityText = true
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
                    self.activeIndices = ActiveIndices(first: self.stepIndex, second: self.stepIndex + 1)
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
            showComplexityText = true
        }
    }

    func shuffleNumbers() {
        numbers.shuffle()
        activeIndices = nil
        stepIndex = 0
        passIndex = 0
        showComplexityText = false
    }
}
