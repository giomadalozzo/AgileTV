import SwiftUI

// Repository List Component
struct RepositoryListView: View {
    let repositories: [Repository]

    var body: some View {
        List(repositories, id: \.name) { repo in
            VStack(alignment: .leading) {
                Text(repo.name)
                    .font(.headline)
                Text(repo.language ?? "Not specified")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }.padding(.bottom)
            .border(.separator)
            .listStyle(.plain)
    }
}
