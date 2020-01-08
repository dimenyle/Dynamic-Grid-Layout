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
    
    init() {
        self.notes = [
            Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
            Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"),
            Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
            Note(text: "Lorem ipsum dolor sit amet."),
            Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"),
            Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua")
        ]
        
        self.notes.forEach {
            let cancellable = $0.objectWillChange.sink(receiveValue: { self.objectWillChange.send() })
            self.cancellables.append(cancellable)
        }
    }
}
