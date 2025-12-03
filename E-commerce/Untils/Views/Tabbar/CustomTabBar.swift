import SwiftUI

struct CustomTabBar: View {
    @EnvironmentObject var language: LanguageManager
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
    @Binding var checkBio: Bool

    let role: UserRoles
    let onFaceIDTap: () -> Void
    @State var progress: CGFloat = 0.1
    
    private let tabs = [
        TabItem(id: 0, icon: "house", titleKey: "home"),
        TabItem(id: 1, icon: "person.2", titleKey: "attendance"),
        TabItem(id: 2, icon: "faceid", titleKey: "schedule", isSpecial: true),
        TabItem(id: 3, icon: "calendar", titleKey: "request"),
        TabItem(id: 4, icon: "person", titleKey: "profile")
    ]
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(tabs, id: \.id) { tab in
                    tabView(for: tab, geometry: geometry)
                }
            }
            .padding(.horizontal, responsiveHorizontalPadding(geometry))
            .padding(.top, responsiveVerticalPadding(geometry))
            .background(backgroundColor)
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(borderColor),
                alignment: .top
            )
        }
        .frame(height: responsiveTabBarHeight)
    }
    
    private func responsiveSpacing(_ geometry: GeometryProxy) -> CGFloat {
        geometry.size.width > 400 ? 6 : 4
    }
    
    private func responsiveIconSize(_ geometry: GeometryProxy) -> CGFloat {
        geometry.size.width > 400 ? 20 : 18
    }
    
    private func responsiveTextSize(_ geometry: GeometryProxy) -> CGFloat {
        geometry.size.width > 400 ? 11 : 10
    }
    
    private func responsiveHorizontalPadding(_ geometry: GeometryProxy) -> CGFloat {
        geometry.size.width > 400 ? 20 : 16
    }
    
    private func responsiveVerticalPadding(_ geometry: GeometryProxy) -> CGFloat {
        geometry.size.width > 400 ? 16 : 12
    }
    
    private var responsiveTabBarHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 90 : 80
    }
    
    // MARK: - Color Scheme Support
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    private var tabColor: Color {
        colorScheme == .dark ? Color.gray : Color.gray.opacity(0.7)
    }
    
    private var borderColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2)
    }
    
    private func tabView(for tab: TabItem, geometry: GeometryProxy) -> some View {
        if tab.isSpecial && role != .admin {
            return AnyView(
                Button(action: {
                            onFaceIDTap()
                }) {
                    VStack(spacing: responsiveSpacing(geometry)) {
                        ZStack {
                            Circle()
                                .fill(Color("Prime"))
                                .frame(
                                    width: responsiveIconSize(geometry) + 40,
                                    height: responsiveIconSize(geometry) + 40
                                )
                            Image(systemName: tab.icon == "faceid" ?   checkBio == true ? "faceid" : "touchid" : tab.icon)
                                .font(.system(
                                    size: responsiveIconSize(geometry),
                                    weight: .medium
                                ))
                                .foregroundColor(.white)
                        }
                        .offset(y: geometry.size.width * -0.024)
                        .animation(.linear, value: progress)
                    }
                }
                .buttonStyle(CustomButtonStyle())
                .frame(maxWidth: .infinity)
                .scaleEffect(selectedTab == tab.id ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
                .accessibilityLabel("Face ID Authentication")
                .accessibilityHint("Tap to perform Face ID authentication")
            )
            
        } else {
            return AnyView(
                Button(action: {
                    withAnimation(.spring){
                        selectedTab = tab.id
                    }
                }) {
                    VStack(spacing: responsiveSpacing(geometry)) {
                        Image(systemName: tab.icon == "faceid" && role == .admin ? "calendar.badge.clock" : tab.icon)
                            .font(.system(
                                size: responsiveIconSize(geometry) + 2,
                                weight: .medium
                            ))
                            .foregroundColor(selectedTab == tab.id ? Color("Prime") : tabColor)
                        Text(language.localizedString(forKey: tab.titleKey))
                            .font(.system(
                                size: responsiveTextSize(geometry),
                                weight: .medium
                            ))
                            .foregroundColor(selectedTab == tab.id ? Color("Prime") : tabColor)
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                    }
                }
                .buttonStyle(CustomButtonStyle())
                .frame(maxWidth: .infinity)
                .scaleEffect(selectedTab == tab.id ? 1.02 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
            )
        }
    }
    private func startProgressAnimation() {
        progress = 0

        withAnimation(.linear(duration: 1.2)) {
            progress = 1.0
        }
    }
}

struct TabItem {
    let id: Int
    let icon: String
    let titleKey: String
    let isSpecial: Bool
    
    init(id: Int, icon: String, titleKey: String, isSpecial: Bool = false) {
        self.id = id
        self.icon = icon
        self.titleKey = titleKey
        self.isSpecial = isSpecial
    }
}
#Preview {
    ContentView()
        .environmentObject(LanguageManager.shared)
}

struct CircularProgressView: View {
  let progress: CGFloat

  var body: some View {
    ZStack {
      Circle()
        .stroke(lineWidth: 15)
        .opacity(0.1)
        .foregroundColor(.blue)

      // Foreground or the actual progress bar
      Circle()
        .trim(from: 0.0, to: min(progress, 1.0))
        .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round))
        .foregroundColor(.blue)
        .rotationEffect(Angle(degrees: 270.0))
        .animation(.linear, value: progress)
    }
  }
}

