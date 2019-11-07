//
//  Extensions.swift
//  Nanotes SwiftUI
//
//  Created by Levente Dimény on 2019. 11. 07..
//  Copyright © 2019. Levente Dimény. All rights reserved.
//

import Foundation

public func withDelay(_ seconds: Double, completionHandler: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completionHandler()
    }
}
