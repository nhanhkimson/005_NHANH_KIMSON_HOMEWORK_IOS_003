
import SwiftUI
enum Loadable<T> {
    case idle
    case loading
    case success(T)
    case failure(T)
}
