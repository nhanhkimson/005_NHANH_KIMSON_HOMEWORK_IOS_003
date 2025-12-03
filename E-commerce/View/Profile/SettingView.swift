import SwiftUI

struct SettingView: View{
    @EnvironmentObject var authVM: AuthenticationViewModel
    @Environment(\.dismiss) var dissmiss
    @Binding var isLogout: Bool
    var body: some View{
        SettingContentView(isLogout: $isLogout)
            .environmentObject(authVM)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dissmiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.backward")
                                .bold()
                        }
                    }
                }
            }
    }
}

struct SettingContentView: View{
    @EnvironmentObject var authVM: AuthenticationViewModel
    @State var showAlert: Bool = false
    @Binding var isLogout: Bool
    var body: some View{
        NavigationStack{
            List{
                Section("General"){
                    NavigationLink{
                        Text("Edit Profile")
                    } label: {
                        ListItem(icon: "person", text: "Edit Profile")
                    }
                    NavigationLink{
                        Text("Change Password")
                    } label: {
                        ListItem(icon: "exclamationmark.lock", text: "Change Password")
                    }
                    NavigationLink{
                        Text("Notification")
                    } label: {
                        ListItem(icon: "bell", text: "Notification")
                    }
                    NavigationLink{
                        Text("Security")
                    } label: {
                        ListItem(icon: "key.viewfinder", text: "Security")
                    }
                }
                Section("Accounts"){
                    NavigationLink{
                        Text("iClould")
                    } label: {
                        ListItem(icon: "icloud", text: "iClould")
                    }
                    NavigationLink{
                        Text("Password and Security")
                    } label: {
                        ListItem(icon: "lock", text: "Password & Security")
                    }
                }
                Section("About"){
                    NavigationLink{
                        Text("General")
                    } label: {
                        ListItem(icon: "info.circle", text: "General")
                    }
                    NavigationLink{
                        Text("Software Update")
                    } label: {
                        ListItem(icon: "arrow.up.right.circle", text: "Softwate Update")
                    }
                }
                Button{
                    showAlert = true
                } label: {
                    ListItem(icon: "rectangle.portrait.and.arrow.right", text: "Logout")
                }
                .alert("Confirmation", isPresented: $showAlert) {
                    Button("Logout", role: .destructive) {
                        // Perform delete action
                        Task{
                            await authVM.logout()
                            isLogout = false
                        }
                        print("Item deleted!")
                    }
                    Button("Cancel", role: .cancel) {
                        showAlert = false
                        print("Deletion cancelled.")
                    }
                } message: {
                    Text("Are you sure you want to delete this item?")
                }
            }
            .toolbar{
                ToolbarItem(placement: .principal){
                    Text("Setting")
                        .font(.title3)
                        .bold()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview{
    ContentView()
}

struct ListItem: View {
    var icon: String = ""
    var text: String = ""
    var body: some View {
        HStack{
            Image(systemName: icon)
                .frame(width: 32)
            Text(text)
        }
        .foregroundStyle(text == "Logout" ? .red : .black)
    }
}


