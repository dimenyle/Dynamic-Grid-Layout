//
//  Notebook.swift
//  Nanotes SwiftUI
//
//  Created by Levente Dimény on 2019. 11. 07..
//  Copyright © 2019. Levente Dimény. All rights reserved.
//

import SwiftUI
import Combine

class Notebook: ObservableObject {
    private var cancellables = [AnyCancellable]()
    
    @Published var notes = [Note]()
    
    var evenNumberedNotes: [Note] {
        notes.enumerated().filter { $0.offset.isMultiple(of: 2) }.map { $0.element }
    }
    
    var oddNumberedNotes: [Note] {
        notes.enumerated().filter { !$0.offset.isMultiple(of: 2) }.map { $0.element }
    }
    
    init() {}
    
    init(notes: [Note]) {
        self.notes = notes
        
        self.notes.forEach {
            let cancellable = $0.objectWillChange.sink(receiveValue: { self.objectWillChange.send() })
            self.cancellables.append(cancellable)
        }
    }
}
