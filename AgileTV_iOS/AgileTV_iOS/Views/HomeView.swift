import SwiftUI

struct HomeView: View {
    @State var username: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Username", text: self.$username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                NavigationLink("Search", destination: ProfileView(username: self.$username))
            }.navigationBarTitle("GitHub Viewer")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

#Preview {
    HomeView()
}
