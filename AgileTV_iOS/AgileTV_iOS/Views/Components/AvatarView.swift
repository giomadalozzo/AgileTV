import SwiftUI

// Avatar component
struct AvatarView: View {
    let avatarURL: String?

    var body: some View {
        AsyncImage(url: URL(string: avatarURL ?? "")) { image in
            image.resizable()
        } placeholder: {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
        }
        .frame(width: 100, height: 100)
        .clipShape(Circle())
        .padding(.top)
    }
}
