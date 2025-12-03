import SwiftUI
struct Home: View {
    var tab = ["Home", "Category"]
    var view = [AnyView(SubHome()), AnyView(Category())]
    @State var selectedTab: Int = 0
    var body: some View {
        NavigationStack{
            UserInfo()
            VStack{
                TopMenu(tab: tab, selectedTab: $selectedTab)
            }
            // display View
            ScrollView{
                if selectedTab == 0{
                    VStack{
                        SubHome()
                    }
                }else{
                    Category()
                }
            }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    Home()
}

import FirebaseAuth
struct UserInfo: View {
    var user = Auth.auth().currentUser

    private var iconName: String {
        // If you have a badge component that takes a system image name, use a sensible default
        // You can customize this to map to your own images later
        return "person.circle.fill"
    }

    private var greetingName: String {
        // Safely obtain a display name or fallback to "there"
        if let name = user?.displayName, !name.isEmpty {
            return name
        }
        return "there"
    }

    var body: some View {
        HStack(alignment: .center){
            bedge(iconName: iconName)
                .clipShape(.circle)
                .frame(width: 42)
            VStack(alignment: .leading, spacing: 8){
                Text("Hi, \(greetingName)")
                    .bold()
                Text("Let's go shopping")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            Spacer()
            HStack{
                Image(systemName: "magnifyingglass")
                Image(systemName: "bell")
            }
            .font(.title2)
        }
        .padding(.horizontal)
        .padding(.vertical, 20)
    }
}
