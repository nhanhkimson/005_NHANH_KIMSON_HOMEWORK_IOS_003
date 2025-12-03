import Kingfisher
import SwiftUI
struct KFImageView: View {
    var imageUrl: String
    var size: CGFloat = 65
    var cornerRadius: CGFloat = .infinity
    var showShadow: Bool = false
    var fillContainer: Bool = false
    
    private var clampedSize: CGFloat {
        guard size.isFinite && size > 0 else { return 65 }
        return size
    }
    
    private var validCornerRadius: CGFloat {
        cornerRadius == .infinity ? clampedSize / 2 : cornerRadius
    }

    var body: some View {
        Group {
            if imageUrl.isEmpty || URL(string: imageUrl) == nil {
                // Show skeleton if URL is empty or invalid
                SkeletonView(
                    shape: RoundedRectangle(cornerRadius: validCornerRadius)
                )
                .frame(width: fillContainer ? nil : clampedSize,
                       height: fillContainer ? nil : clampedSize)
                .frame(maxWidth: fillContainer ? .infinity : nil,
                       maxHeight: fillContainer ? .infinity : nil)
            } else {
                KFImage(URL(string: imageUrl))
                    .placeholder {
                        SkeletonView(
                            shape: RoundedRectangle(cornerRadius: validCornerRadius)
                        )
                        .frame(width: fillContainer ? nil : clampedSize,
                               height: fillContainer ? nil : clampedSize)
                        .frame(maxWidth: fillContainer ? .infinity : nil,
                               maxHeight: fillContainer ? .infinity : nil)
                    }
                    .onFailure { error in
                        print("Error loading image: \(error)")
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: fillContainer ? nil : clampedSize,
                           height: fillContainer ? nil : clampedSize)
                    .frame(maxWidth: fillContainer ? .infinity : nil,
                           maxHeight: fillContainer ? .infinity : nil)
                    .clipShape(RoundedRectangle(cornerRadius: validCornerRadius))
                    .shadow(radius: showShadow ? 4 : 0)
            }
        }
    }
}
