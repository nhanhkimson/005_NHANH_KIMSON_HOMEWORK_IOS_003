import SwiftUI

struct SkeletonView<S: Shape>: View {
    var shape: S
    var color: Color
    @State private var isAnimating: Bool = false

    init(shape: S, color: Color = .gray.opacity(0.1)) {
        self.shape = shape
        self.color = color
    }

    var body: some View {
        shape
            .fill(color)
            .overlay{
                GeometryReader{
                    let size = $0.size
                    let skeletonWidth = size.width / 2
                    let blurRaduis = max(skeletonWidth / 2, 30)
                    let blurDiameter = blurRaduis * 2
                    let minX = -(skeletonWidth + blurDiameter)
                    let maxX = size.width + skeletonWidth + blurDiameter
                    
                    Rectangle()
                        .fill(.gray.opacity(0.2))
                        .frame(width: skeletonWidth, height: size.height * 2)
                        .frame(height: size.height)
                        .blur(radius: blurRaduis)
                        .rotationEffect(.init(degrees: rotation))
                        .blendMode(.softLight)
                        .offset(x: isAnimating ? maxX: minX)
                    
                }
            }
            .clipShape(shape)
            .compositingGroup()
            .onAppear{
                guard !isAnimating else { return }
                withAnimation(animation){
                    isAnimating = true
                }
            }
            .onDisappear{
                isAnimating = false
            }
    }
    var rotation: Double{
        return 5
    }
    var animation: Animation{
        .easeInOut(duration: 1.5).repeatForever(autoreverses: false)
    }
}

#Preview {
    SkeletonView(shape: Circle())
        .frame(width: 100, height: 100)
}
