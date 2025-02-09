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

            // When loaded the avatar, display the UI. Until then, ProgressView will be displayed
            if viewModel.avatarLoaded {
                AvatarView(avatarURL: viewModel.avatarURL)
                Text(username)
                    .padding()
                if viewModel.repositories.isEmpty {
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
                Task {
                    await viewModel.fetchRepositories(for: self.username)
                }
            }
            .alert(item: $viewModel.error) { error in
                Alert(
                    title: Text("Oops!"),
                    message: Text(error.errorDescription ?? "A network error has occurred. Check your Internet connection and try again later."),
                    dismissButton: Alert.Button.default(
                        Text("OK"), action: { presentationMode.wrappedValue.dismiss() }
                        )
                )
            }
    }
}

