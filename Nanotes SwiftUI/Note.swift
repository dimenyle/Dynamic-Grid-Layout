//
//  Note.swift
//  Nanotes SwiftUI
//
//  Created by Levente Dimény on 2019. 11. 07..
//  Copyright © 2019. Levente Dimény. All rights reserved.
//

import SwiftUI
import Combine

class Note: ObservableObject, Identifiable {
    let id = UUID()
    var text: String
    @Published var xOffset: CGFloat = 0.0
    
    init(text: String) {
        self.text = text
    }
}
