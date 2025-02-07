import SwiftUI
import UIKit

struct ProfileView: View {
    var name = "Name"
    var repo = "Repo"
    var language = "Language"
    @Environment(\.presentationMode) var presentationMode

    init() {
        UINavigationBar.appearance()
    }

    var body: some View {
        VStack{
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                    .foregroundStyle(Color.white)
                    .background(Color.secondary)
                    .clipShape(Circle())
                Text(name)
                    .padding()
            ScrollView {
                ForEach(0..<20) { x in
                    Text("\(x)")
                    Divider()
                }
            }.background(.white)
                .border(.separator)
        }.ignoresSafeArea()
            .padding(.top)
            .background(.ultraThinMaterial)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                        })
    }
}

#Preview {
    ProfileView()
}
