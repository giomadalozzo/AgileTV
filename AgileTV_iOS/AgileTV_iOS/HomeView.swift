//
//  ContentView.swift
//  AgileTV_iOS
//
//  Created by Giovanni Madalozzo on 07/02/25.
//

import SwiftUI

struct HomeView: View {
    @State var username: String = ""
    var body: some View {
            NavigationView {
                VStack {
                    TextField("Username", text: self.$username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Search") {
                        print(self.$username)
                    }

                }.navigationTitle("GitHub Viewer")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)

            }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    HomeView()
}
