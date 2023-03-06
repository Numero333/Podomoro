//
//  TimerOnView.swift
//  Minuteur
//
//  Created by François-Xavier Méité on 23/02/2022.
//

import SwiftUI

struct TimerView: View {
    
    @ObservedObject var timerManager = TimerManager()
    
    var body: some View {
        
        ZStack {
            Background()
            VStack {
                Spacer()
                Text("\(timerManager.titleSession)")
                    .font(.system(size: UIScreen.main.bounds.width / 10, weight: .regular, design: .rounded))
                    .foregroundColor(Color(#colorLiteral(red: 0.8401103616, green: 0.9972837567, blue: 1, alpha: 1)))
                    .padding()
                Spacer()
                Spacer()
                ZStack {
                    
                    Group {
                        
                        //ProgressView des cercles
                        switch timerManager.sessionState {
                        case .focus :
                            CircleProgress(stored: $timerManager.focus, remain: Home().$storeFocus)
                        case .shortBreak :
                            CircleProgress(stored: $timerManager.shortBreak, remain: Home().$shortBreak)
                        case .longBreak :
                            CircleProgress(stored: $timerManager.longBreak, remain: Home().$longBreak)
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width / 1, height: UIScreen.main.bounds.height / 3)
                    
                    VStack {
                        
                        Text("Temps restant :")
                            .font(.system(size: UIScreen.main.bounds.width / 17, weight: .regular, design: .rounded))
                            .foregroundColor(.white)
                        
                        switch timerManager.sessionState {
                        case .focus:
                            
                            RemainingTime(store: $timerManager.focus)
                        case .shortBreak:
                            RemainingTime(store: $timerManager.shortBreak)
                        case .longBreak:
                            RemainingTime(store: $timerManager.longBreak)
                        }
                    }
                }
                
                Spacer()
                
                Spacer()
                ZStack {
                    
                    Text("Podomoro restant : \(timerManager.storeCountSession)")
                        .font(.system(size: UIScreen.main.bounds.width / 15, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                }
                HStack {
                    
                    if timerManager.focus == 0 || timerManager.shortBreak == 0 || timerManager.longBreak == 0 {
                        
                        Button(action: {
                            timerManager.next()
                        }, label: {
                            ButtonLabel(title: "chevron.right", imageName: "Suivant")
                        })
                        
                    } else {
                        
                        if timerManager.isPlaying == false {
                            Button(action: {
                                
                                timerManager.isPlaying.toggle()
                                self.timerManager.timerState == .play ? self.timerManager.pause() : self.timerManager.start()
                                
                            }, label: {
                                ButtonLabel(title: "play",imageName: "Lecture")
                            })
                            
                        } else {
                            Spacer()
                            Button(action: {
                                
                                timerManager.isPlaying.toggle()
                                self.timerManager.timerState == .play ? self.timerManager.pause() : self.timerManager.start()
                                
                            }, label: {
                                ButtonLabel(title: "pause",imageName: "Pause")
                            })
                            Spacer()
                            Button(action: {
                                
                                timerManager.isPlaying.toggle()
                                self.timerManager.reset()
                                
                            }, label: {
                                ButtonLabel(title: "gobackward", imageName: "Reset")
                            })
                            
                            Spacer()
                            
                            Button(action: {
                                timerManager.skip()
                            }, label: {
                                ButtonLabel(title: "forward.end", imageName: "Passer")
                            })
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .onDisappear(perform: {
                timerManager.fullReset()
            })
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TimerOnView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}

struct CircleProgress: View {
    @Binding var stored: Double
    @Binding var remain: Double
    var body: some View {
        
        Circle()
            .stroke(lineWidth: 20)
            .foregroundColor(.white)
            .opacity(0.2)
            .shadow(color: .black, radius: 1, x: 2, y: 2)
        
        Circle()
            .trim(from: 0.0, to: min(stored / 60, (stored / 60) / remain))
            .stroke(AngularGradient(gradient : Gradient(colors: [Color(#colorLiteral(red: 0.3840473294, green: 0.5174900293, blue: 0.9962539077, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.5908941627, green: 0.850129962, blue: 0.8806149364, alpha: 1)), Color(#colorLiteral(red: 0.3840473294, green: 0.5174900293, blue: 0.9962539077, alpha: 1))]), center: .center), style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
            .shadow(color: .white, radius: 0, x: 2, y: 2)
            .rotationEffect(Angle(degrees: 270))
            .animation(.easeInOut(duration: 0.5), value: stored / 60)
    }
}

struct ButtonLabel: View {
    
    var title: String
    var imageName: String
    
    var body: some View {
        VStack {
            Image(systemName: title)
                .font(.largeTitle)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(#colorLiteral(red: 0.7554660439, green: 1, blue: 1, alpha: 1)), lineWidth: 2)
            )
            Text(imageName)
        }
    }
}

struct RemainingTime: View {
    
    @Binding var store: Double
    
    var body: some View {
        Text(String(format: "%00i:%02i", Int(store) / 60, Int(store.truncatingRemainder(dividingBy: 60.0))))
            .font(.system(size: UIScreen.main.bounds.width / 6, weight: .regular, design: .rounded))
            .foregroundColor(.white)
        
//        Text(String(format: "%.2f", store))
//            .font(.system(size: UIScreen.main.bounds.width / 5, weight: .regular, design: .rounded))
//            .foregroundColor(.white)
    }
}
