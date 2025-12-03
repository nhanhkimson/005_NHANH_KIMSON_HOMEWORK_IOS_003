import SwiftUI

struct ColorSchemePicker: View {
    @AppStorage("appearance") private var selectedAppearance: Appearance = .system
    @Namespace private var animation
    @State private var isTransitioning = false
    
    var colorScheme: ColorScheme? {
        switch selectedAppearance {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            headerView
            optionsView
            Spacer()
        }
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .preferredColorScheme(colorScheme)
        .presentationDetents([.fraction(0.4)])
        .presentationDragIndicator(.visible)
        .padding(.top)
        .opacity(isTransitioning ? 0.8 : 1.0)
        .scaleEffect(isTransitioning ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isTransitioning)
    }
    
    private var headerView: some View {
        HStack {
            Image(systemName: "paintpalette.fill")
                .foregroundColor(.blue)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 1) {
                Text("Appearance")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Choose your preferred theme")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    private var optionsView: some View {
        VStack(spacing: 0) {
            ForEach(Appearance.allCases) { appearance in
                optionRow(for: appearance)
                
                if appearance != Appearance.allCases.last {
                    Divider().padding(.leading, 52)
                }
            }
        }
    }
    
    private func optionRow(for appearance: Appearance) -> some View {
        Button {
            Task {
                await smoothAppearanceChange(to: appearance)
            }
        } label: {
            HStack(spacing: 12) {
                iconView(for: appearance)
                textView(for: appearance)
                Spacer()
                selectionIndicator(for: appearance)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .background(
                selectedAppearance == appearance
                ? Color.blue.opacity(0.1)
                : Color.clear
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(isTransitioning)
    }
    @MainActor
    private func smoothAppearanceChange(to newAppearance: Appearance) async {
        guard selectedAppearance != newAppearance && !isTransitioning else { return }
        isTransitioning = true
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            selectedAppearance = newAppearance
        }
        do {
            try await Task.sleep(nanoseconds: 300_000_000)
        } catch {
            print("Sleep interrupted: \(error)")
        }
        
        withAnimation(.easeInOut(duration: 0.2)) {
            isTransitioning = false
        }
    }
    
    private func iconView(for appearance: Appearance) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(iconBackgroundColor(for: appearance))
                .frame(width: 32, height: 32)
            
            Image(systemName: iconName(for: appearance))
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(iconColor(for: appearance))
        }
        .opacity(isTransitioning ? 0.7 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isTransitioning)
    }
    
    private func textView(for appearance: Appearance) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(appearance.rawValue)
                .font(.callout)
                .fontWeight(.medium)
            
            Text(description(for: appearance))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .opacity(isTransitioning ? 0.8 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isTransitioning)
    }
    
    private func selectionIndicator(for appearance: Appearance) -> some View {
        ZStack {
            if selectedAppearance == appearance {
                Circle()
                    .fill(Color.blue)
                    .matchedGeometryEffect(id: "selection", in: animation)
                    .frame(width: 20, height: 20)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Circle()
                    .stroke(Color.secondary.opacity(0.3), lineWidth: 1.5)
                    .frame(width: 18, height: 18)
            }
        }
        .scaleEffect(isTransitioning ? 0.9 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isTransitioning)
    }
    
    private func iconName(for appearance: Appearance) -> String {
        switch appearance {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "iphone"
        }
    }
    
    private func description(for appearance: Appearance) -> String {
        switch appearance {
        case .light: return "Always light"
        case .dark: return "Always dark"
        case .system: return "Same as system"
        }
    }
    
    private func iconColor(for appearance: Appearance) -> Color {
        switch appearance {
        case .light: return .orange
        case .dark: return .purple
        case .system: return .blue
        }
    }
    
    private func iconBackgroundColor(for appearance: Appearance) -> Color {
        let isSelected = selectedAppearance == appearance
        switch appearance {
        case .light: return isSelected ? .orange.opacity(0.2) : .orange.opacity(0.1)
        case .dark: return isSelected ? .purple.opacity(0.2) : .purple.opacity(0.1)
        case .system: return isSelected ? .blue.opacity(0.2) : .blue.opacity(0.1)
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ColorSchemePicker()
        .environmentObject(LanguageManager.shared)
}
