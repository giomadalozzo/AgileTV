import SwiftUI

// Empty state component
/// In case the user has no repositories on GitHub
struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "tray")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray)
            Text("No repositories found")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        }
        .frame(maxHeight: .infinity)
    }
}
