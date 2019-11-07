//
//  NotePreview.swift
//  Nanotes SwiftUI
//
//  Created by Levente Dimény on 2019. 11. 07..
//  Copyright © 2019. Levente Dimény. All rights reserved.
//

import SwiftUI

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
                .blur(radius: abs(note.xOffset) / 50)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.gray.opacity(0.5), radius: 0.5, x: flipped ? -1.5 : 1.5, y: 1.5)
        .rotation3DEffect(.degrees(flipped ? 180.0 : 0.0), axis: (x: 0, y: 1, z: 0))
//        .rotation3DEffect(.degrees(flipped ? -45.0 : 0.0), axis: (x: 0, y: 1, z: 0))
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
