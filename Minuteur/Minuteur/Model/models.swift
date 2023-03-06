//
//  models.swift
//  Minuteur
//
//  Created by François-Xavier Méité on 23/02/2022.
//

import Foundation
import SwiftUI

enum TimerState {
    case play
    case pause
    case stop
}

enum SessionState {
    case focus
    case shortBreak
    case longBreak
}
