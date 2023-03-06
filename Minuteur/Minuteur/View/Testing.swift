//
//  Testing.swift
//  Minuteur
//
//  Created by François-Xavier on 04/03/2023.
//

import SwiftUI

struct Testing: View {
    
    var ooo = UserDefaults.standard.double(forKey: "focus")
    
    var body: some View {
        //Text("focus")
        
        Button {
            print(ooo)
        } label: {
            Text("click me")
        }
    }
}

struct Testing_Previews: PreviewProvider {
    static var previews: some View {
        Testing()
    }
}
