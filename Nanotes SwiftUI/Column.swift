//
//  Column.swift
//  Nanotes SwiftUI
//
//  Created by Levente Dimény on 2019. 11. 07..
//  Copyright © 2019. Levente Dimény. All rights reserved.
//

import SwiftUI

struct Column: View {
    @State private var dragging = false
    
    @State var notes: [Note]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(notes, id: \.id) { note in
                NotePreview(note: note)
                    .opacity(1.0 - Double(abs(note.xOffset) / 100))
                    .offset(x: note.xOffset, y: 0.0)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.dragging = true
                                
                                withAnimation(.default) {
                                    note.xOffset = value.translation.width
                                }
                            }
                            
                            .onEnded { value in
                                self.dragging = false
                                
                                if abs(value.translation.width) >= 100 {
                                    withAnimation(.easeOut(duration: 0.25)) {
                                        note.xOffset = 300.0
                                        
                                        withDelay(0.20) {
                                            self.notes.remove(at: self.notes.firstIndex(where: { $0.id == note.id }) ?? 0)
                                        }
                                    }
                                } else {
                                    withAnimation(.interpolatingSpring(mass: 1, stiffness: 35, damping: 35, initialVelocity: 10)) {
                                        note.xOffset = 0.0
                                    }
                                }
                            }
                        )
                }
            
            Spacer()
        }
        .zIndex(dragging ? 0 : 1)
    }
}
