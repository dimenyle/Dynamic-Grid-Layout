//
//  ContentView.swift
//  Nanotes SwiftUI
//
//  Created by Levente Dimény on 2019. 11. 05..
//  Copyright © 2019. Levente Dimény. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var notebook =
        Notebook(notes: [
            Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
            Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"),
            Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
            Note(text: "Lorem ipsum dolor sit amet."),
            Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor"),
            Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua")
        ])
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.25).edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: true) {
                HStack(alignment: .top) {
                    Column(notes: notebook.oddNumberedNotes)
                    Column(notes: notebook.evenNumberedNotes)
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
