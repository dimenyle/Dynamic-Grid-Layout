//
//  ContentView.swift
//  Nanotes SwiftUI
//
//  Created by Levente Dimény on 2019. 11. 05..
//  Copyright © 2019. Levente Dimény. All rights reserved.
//

import SwiftUI
import Combine

struct NoteListView: View {
    @ObservedObject var notebook = Notebook()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.opacity(0.25).edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: true) {
                    HStack(alignment: .top) {
                        NoteColumnView(notes: self.notebook.oddNumberedNotes)
                            .frame(width: (geometry.size.width - 32) / 2)
                        NoteColumnView(notes: self.notebook.evenNumberedNotes)
                            .frame(width: (geometry.size.width - 32) / 2)
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NoteListView()
    }
}
