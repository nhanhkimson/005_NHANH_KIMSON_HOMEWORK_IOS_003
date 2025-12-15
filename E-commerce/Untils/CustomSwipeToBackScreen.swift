import Foundation
import UIKit
import SwiftUI
// A custom view to force navigation to the navigation stack
struct NavigationStackView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(NavigationControllerAccessor())
    }
}

struct NavigationControllerAccessor: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        guard let navigationController = uiViewController.navigationController else { return }
        navigationController.interactivePopGestureRecognizer?.isEnabled = true
    }
}
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
