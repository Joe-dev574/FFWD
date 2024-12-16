//
//  HapticManager.swift
//  FFWD
//
//  Created by Joseph DeWeese on 12/15/24.
//

import Foundation
import SwiftUI


class HapticManager {
    
    static private let hapticFeedbackGenerator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        hapticFeedbackGenerator.notificationOccurred(type)
    
    }
}
