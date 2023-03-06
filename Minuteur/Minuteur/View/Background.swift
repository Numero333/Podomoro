//
//  Background.swift
//  Minuteur
//
//  Created by François-Xavier Méité on 03/03/2022.
//

import SwiftUI

struct Background: View {
    var body: some View {
        Color(#colorLiteral(red: 0.2482440174, green: 0.263227433, blue: 0.2843994498, alpha: 1)).ignoresSafeArea()
    }
}

struct Background_Previews: PreviewProvider {
    static var previews: some View {
        Background()
    }
}
