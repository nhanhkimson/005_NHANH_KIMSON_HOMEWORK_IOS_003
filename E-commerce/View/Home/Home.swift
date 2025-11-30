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
    }
}

#Preview {
    Home()
}

struct UserInfo: View {
    var user: UserApp = UserApp.user
    var body: some View {
        HStack(alignment: .center){
                bedge(iconName: user.image)
                    .clipShape(.circle)
                    .frame(width: 42)
            VStack(alignment: .leading, spacing: 8){
                    Text("Hi, \(user.fullName)")
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
