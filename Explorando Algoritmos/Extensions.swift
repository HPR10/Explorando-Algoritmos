//
//  Extensions.swift
//  Explorando Algoritmos
//
//  Created by Hugo Pinheiro  on 13/07/24.
//

import Foundation
import SwiftUI

// MARK: Modificador de para textos ou numeros expoentes

extension Text {
    func superscript(_ text: String) -> Text {
        self + Text(text).baselineOffset(5).font(.system(size:10))
    }
}


