import SwiftUI
struct CustomUnderline: ViewModifier {
    let color: Color
    let thickness: CGFloat
    let offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    Rectangle()
                        .fill(color)
                        .frame(height: thickness)
                        .offset(y: geo.size.height + offset)
                }
            )
    }
}
extension View {
    func customUnderline(color: Color = .black, thickness: CGFloat = 1, offset: CGFloat = 0) -> some View {
        self.modifier(CustomUnderline(color: color, thickness: thickness, offset: offset))
    }
}
