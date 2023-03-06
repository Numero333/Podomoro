//
//  TimerManager.swift
//  Minuteur
//
//  Created by François-Xavier Méité on 23/02/2022.
//

import Foundation
//import SwiftUI
import AVKit

class TimerManager: ObservableObject {
    
    var storeFocus = Home().storeFocus
    //UserDefaults.standard.double(forKey: "focus")
    var storeSBreak = Home().shortBreak
    //UserDefaults.standard.double(forKey: "shortBreak")
    var storeLBreak = Home().longBreak
    //UserDefaults.standard.double(forKey: "longBreak")
    var progress = 0.0
    
    @Published var storeCountSession: Int = Home().countSession
    @Published var focus: Double = Home().storeFocus * 60
    @Published var shortBreak: Double = Home().shortBreak * 60
    @Published var longBreak: Double = Home().longBreak * 60
    
    // init on :
    @Published var isPlaying = false
    @Published var titleSession = "Concentration"
    @Published var sessionState: SessionState = .focus
    
    
    var timerState: TimerState = .pause
    var timer = Timer()
    
    var player: AVAudioPlayer?
    
    func start() {
        
        switch sessionState {
        case .focus:
            
            titleSession = "Rester concentré !"
            
            timerState = .play
            sessionState = .focus
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {timer in
                
                if self.focus == 0 {
                    self.playSound()
                    timer.invalidate()
                    self.isPlaying.toggle()
                    self.timerState = .pause
                    //self.timer = Timer()
                } else {
                    self.focus -= 1
                }
            })
            
        case .shortBreak:
            
            timerState = .play
            sessionState = .shortBreak
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {timer in
                
                if self.shortBreak == 0 {
                    self.playSound()
                    timer.invalidate()
                    self.isPlaying.toggle()
                    self.timerState = .pause
                    
                } else {
                    self.shortBreak -= 1
                }
            })
            
        case .longBreak:
            
            timerState = .play
            sessionState = .longBreak
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {timer in
                
                if self.longBreak == 0 {
                    self.playSound()
                    timer.invalidate()
                    self.isPlaying.toggle()
                    self.timerState = .pause
                    self.playSound()
                } else {
                    self.longBreak -= 1
                }
            })
        }
    }
    
    func reset() {
        self.timerState = .stop
        timer.invalidate()
        switch self.sessionState {
        case .focus:
            self.focus = storeFocus * 60
        case .shortBreak:
            self.shortBreak = storeSBreak * 60
        case .longBreak:
            self.longBreak = storeLBreak * 60
        }
        
    }
    
    func pause() {
        self.timerState = .pause
        timer.invalidate()
    }
    
    func fullReset() {
        self.focus = Home().storeFocus * 60
        self.shortBreak = Home().shortBreak * 60
        self.longBreak = Home().longBreak * 60
        
        self.isPlaying = false
        self.titleSession = "Concentration"
        self.sessionState = .focus
        
        self.timerState = .pause
        //timerManager.timer = Timer()
        
        self.timer.invalidate()
        self.focus = Home().storeFocus * 60
        
        self.storeCountSession = Home().countSession
    }
    
    func skip() {
        
        self.isPlaying.toggle()
        self.timerState = .pause
        self.timer.invalidate()
        
        switch sessionState {
            
        case .focus:
            
            self.storeCountSession -= 1
            self.focus = Home().storeFocus * 60
            TimerView().timerManager.reset()
            
            if self.storeCountSession == 0 {
                self.sessionState = .longBreak
                self.titleSession = "Longue pause"
            } else {
                self.sessionState = .shortBreak
                self.titleSession = "Petite Pause"
            }
            
        case .shortBreak:
            
            if self.storeCountSession == 0 {
                TimerView().timerManager.reset()
                self.titleSession = "Longue Pause"
                self.sessionState = .longBreak
                self.shortBreak = Home().shortBreak * 60
                
            } else {
                TimerView().timerManager.reset()
                self.titleSession = "Concentration"
                self.sessionState = .focus
                self.shortBreak = Home().shortBreak * 60
            }
            
        case .longBreak:
            self.titleSession = "Concentration"
            self.sessionState = .focus
            self.longBreak = Home().longBreak * 60
            self.storeCountSession = Home().countSession
        }
    }
    
    func next() {
        
        switch sessionState {
            
        case .focus:
            self.storeCountSession -= 1
            self.focus = Home().storeFocus * 60
            
            if self.storeCountSession == 0 {
                self.sessionState = .longBreak
                self.titleSession = "Longue pause"
            } else {
                self.sessionState = .shortBreak
                self.titleSession = "Petite Pause"
            }
            
        case .shortBreak:
            
            if self.storeCountSession == 0 {
                self.shortBreak = Home().shortBreak * 60
                self.sessionState = .longBreak
                self.titleSession = "Longue Pause"
            }
            
            if self.storeCountSession >= 1 {
                self.shortBreak = Home().shortBreak * 60
                self.sessionState = .focus
                self.titleSession = "Resté concentrer"
            }
            
        case .longBreak:
            
            self.storeCountSession = Home().countSession
            self.longBreak = Home().longBreak * 60
            self.sessionState = .focus
            self.titleSession = "Nouvelle Session"
            
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "gong", withExtension: ".mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch _ {
            print("error sound")
        }
    }
}
