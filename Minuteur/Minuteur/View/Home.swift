//
//  ContentView.swift
//  Minuteur
//
//  Created by François-Xavier Méité on 23/02/2022.
//

import SwiftUI

struct Home: View {
    
    @AppStorage("focus") var storeFocus: Double = 25
    @AppStorage("shortBreak") var shortBreak = 5.0
    @AppStorage("longBreak") var longBreak = 15.0
    @AppStorage("countSession") var countSession: Int = 4
    
    
    @State private var isEditing = false
    @State var timerState: TimerState = .pause
    
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
    }
    
    var body: some View {
        
        
        let formattedFocus = String(format: "%.0f", storeFocus)
        let formattedShort = String(format: "%.0f", shortBreak)
        let formattedlong = String(format: "%.0f", longBreak)
        
        NavigationView {
            ZStack {
                Background()
                VStack(alignment: .leading) {
                    
                    Text("Définissez la durée de vos sessions de concentration et de pause")
                        .font(.system(size: UIScreen.main.bounds.width / 11, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding()
                    
                    Text("Podomoro:")
                        .font(.system(size: UIScreen.main.bounds.width / 15, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                    
                    Picker("Number", selection: $countSession) {
                        ForEach(1...6, id:\.self){ i in
                            Text(String(i))
                        }
                    }
                    .onChange(of: countSession) { new in
                        countSession = new
                    }
                    .pickerStyle(.segmented)
                    .background(Color(#colorLiteral(red: 0.8401103616, green: 0.9972837567, blue: 1, alpha: 1))
                        .cornerRadius(10))
                    .padding(.horizontal, 30)
                    .padding(.bottom)
                    
                    
                    Text("Concentration:  \(formattedFocus) minutes")
                        .font(.system(size: UIScreen.main.bounds.width / 15, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                    
                    Slider(
                        value: $storeFocus,
                        in: 1...60,
                        step: 1,
                        onEditingChanged: { editing in
                            isEditing = editing
                            
                        }
                    ).padding(.horizontal, UIScreen.main.bounds.width / 10)
                    
                    
                    Text("Petite pause:  \(formattedShort) minutes")
                        .font(.system(size: UIScreen.main.bounds.width / 15, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                    Slider(
                        value: $shortBreak,
                        in: 1...30,
                        step: 1,
                        onEditingChanged: { editing in
                            isEditing = editing
                        }
                    ).padding(.horizontal, UIScreen.main.bounds.width / 10)
                    
                    Text("Longue Pause:  \(formattedlong) minutes")
                        .font(.system(size: UIScreen.main.bounds.width / 15, weight: .regular, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                    
                    Slider(
                        value: $longBreak,
                        in: 1...60,
                        step: 1,
                        onEditingChanged: { editing in
                            isEditing = editing
                        }
                    ).padding(.horizontal, UIScreen.main.bounds.width / 10)
                        .padding(.bottom)
                    NavigationLink(destination: TimerView(), label: {
                        ZStack {
                            Capsule()
                                .frame(width: UIScreen.main.bounds.width / 1.1, height: UIScreen.main.bounds.height / 13)
                                .foregroundColor(Color(#colorLiteral(red: 0.8401103616, green: 0.9972837567, blue: 1, alpha: 1)))
                                .padding(.horizontal)
                                .padding()
                            Text("Début")
                                .font(.system(size: UIScreen.main.bounds.width / 15, weight: .regular, design: .rounded))
                                .foregroundColor(.black)
                        }
                    })
                }.navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
