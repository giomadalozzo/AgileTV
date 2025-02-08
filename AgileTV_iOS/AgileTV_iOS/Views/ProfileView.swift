import SwiftUI

struct ProfileView: View {
    @Binding var username: String
    @StateObject var viewModel = ViewModel()
    @Environment(\.presentationMode) var presentationMode

    init(username: Binding<String>) {
        self._username = username
    }

    var body: some View {
        VStack{
            if viewModel.avatarLoaded {
                AvatarView(avatarURL: viewModel.avatarURL)
                Text(username)
                    .padding()
                if viewModel.isEmpty {
                    EmptyStateView()
                } else {
                    RepositoryListView(repositories: viewModel.repositories)
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

        }.frame( maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
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
            .onAppear {
                viewModel.fetchRepositories(username: self.username)
            }
            .alert(item: $viewModel.error) { error in
                Alert(
                    title: Text("Oops!"),
                    message: Text(error.errorDescription),
                    dismissButton: Alert.Button.default(
                        Text("OK"), action: { presentationMode.wrappedValue.dismiss()}
                        )
                )
            }
    }
}

