//
//  ContentView.swift
//  Nanotes SwiftUI
//
//  Created by Levente Dimény on 2019. 11. 05..
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

class Notebook: ObservableObject {
    private var cancellables = [AnyCancellable]()
    
    @Published var notes = [Note]()
    
    init() {}
    
    init(notes: [Note]) {
        self.notes = notes
        
        self.notes.forEach({
            let cancellable = $0.objectWillChange.sink(receiveValue: { self.objectWillChange.send() })
            self.cancellables.append(cancellable)
        })
    }
}

public func withDelay(_ seconds: Double, completionHandler: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completionHandler()
    }
}

struct ContentView: View {
    @ObservedObject var notebook = Notebook(notes: [
        Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
        Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua"),
        Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
        Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."),
        Note(text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    ])
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.25).edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: true) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach((0..<notebook.notes.count).filter { !$0.isMultiple(of: 2) }, id: \.self) { index in
                            NotePreview(note: self.notebook.notes[index])
                                .opacity(1.0 - Double(abs(self.notebook.notes[index].xOffset) / 100))
                                .offset(x: self.notebook.notes[index].xOffset, y: 0.0)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            guard value.translation.width.isLess(than: 0.0) else { return }
                                            
                                            withAnimation(.default) {
                                                self.notebook.notes[index].xOffset = value.translation.width
                                            }
                                        }
                                        
                                        .onEnded { value in
                                            if value.translation.width <= -100 {
                                                withAnimation(.easeOut(duration: 0.25)) {
                                                    self.notebook.notes[index].xOffset = -300.0
                                                    
                                                    withDelay(0.20) {
                                                        self.notebook.notes.remove(at: index)
                                                    }
                                                }
                                            } else {
                                                withAnimation(.interpolatingSpring(mass: 1, stiffness: 35, damping: 35, initialVelocity: 10)) {
                                                    self.notebook.notes[index].xOffset = 0.0
                                                }
                                            }
                                        }
                                    )
                            }
                        
                        Spacer()
                    }
                    
                        
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach((0..<notebook.notes.count).filter { $0.isMultiple(of: 2) }, id: \.self) { index in
                            NotePreview(note: self.notebook.notes[index])
                                .opacity(1.0 - Double(abs(self.notebook.notes[index].xOffset) / 100))
                                .offset(x: self.notebook.notes[index].xOffset, y: 0.0)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            guard !value.translation.width.isLess(than: 0.0) else { return }
                                            
                                            withAnimation(.default) {
                                                self.notebook.notes[index].xOffset = value.translation.width
                                            }
                                        }
                                        
                                        .onEnded { value in
                                            if value.translation.width >= 100 {
                                                withAnimation(.easeOut(duration: 0.25)) {
                                                    self.notebook.notes[index].xOffset = 300.0
                                                    
                                                    withDelay(0.20) {
                                                        self.notebook.notes.remove(at: index)
                                                    }
                                                }
                                            } else {
                                                withAnimation(.interpolatingSpring(mass: 1, stiffness: 35, damping: 35, initialVelocity: 10)) {
                                                    self.notebook.notes[index].xOffset = 0.0
                                                }
                                            }
                                        }
                                    )
                            }
                        
                        Spacer()
                    }
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

struct NotePreview: View {
    @State private var flipped = false
    @State private var textOpacity = 1.0
    
    @ObservedObject var note: Note
    
    var body: some View {
        VStack(spacing: 8) {
            Text(note.text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(10)
                .opacity(textOpacity)
        }
        .blur(radius: abs(self.note.xOffset) / 25)
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.gray.opacity(0.5), radius: 0.5, x: flipped ? -1.5 : 1.5, y: 1.5)
        .rotation3DEffect(.degrees(flipped ? 180.0 : 0.0), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation(.linear(duration: 0.5)) {
                self.flipped.toggle()
            }
            
            withAnimation(Animation.linear(duration: 0.1).delay(0.20)) {
                self.textOpacity = self.textOpacity == 1.0 ? 0.0 : 1.0
            }
        }
    }
}
