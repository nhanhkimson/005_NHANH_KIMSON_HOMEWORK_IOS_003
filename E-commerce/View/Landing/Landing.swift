//
//  Landing.swift
//  Psakhmer
//
//  Created by Apple on 8/31/25.
//
import SwiftUI
struct Landing: View{
    @EnvironmentObject var authVM: AuthenticationViewModel
    var pages: [AnyView] = [AnyView(LandingOne(iamge: "watchTissot")), AnyView(LandingOne(iamge: "bagboy1")), AnyView(LandingOne(iamge: "watchWoman"))]
    @State private var isLogin = UserApp.user.isLogin
    @Binding var isHome: Bool
    var body: some View{
        NavigationStack{
            VStack{
                TabView{
                    ForEach(pages.indices, id: \.self){ index in
                        pages[index]
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                VStack(spacing: 18){
                    PrimaryButton(title: "logout") {
                        isLogin = true
                    }
                    .navigationDestination(isPresented: $isLogin){
                        CreateAccount(isLoged: $isHome)
                            .environmentObject(authVM)
                            .navigationBarBackButtonHidden(true)
                    }
                    PrimaryButton(title: "Already have an account"){
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
#Preview{
    ContentView()
}
