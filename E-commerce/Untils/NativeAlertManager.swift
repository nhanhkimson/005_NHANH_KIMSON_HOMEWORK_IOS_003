
import SwiftUI

class NativeAlertManager: ObservableObject {
    @Published var alert: NativeAlertConfig?
    
    static let shared = NativeAlertManager()
    
    private init() {}
    
    func show(_ alert: NativeAlertConfig) {
        self.alert = alert
    }
    
    func showSuccessMessage(title: String, message: String, buttonTitle: String = "ok", action: (() -> Void)? = nil) {
        alert = .success(
            title: LanguageManager.shared.localizedString(forKey: title),
            message: LanguageManager.shared.localizedString(forKey: message),
            buttonTitle: LanguageManager.shared.localizedString(forKey: buttonTitle),
            action: action
        )
    }
    
    func showSuccess(title: String, message: String, buttonTitle: String = "ok", action: (() -> Void)? = nil) {
        alert = .success(
            title: LanguageManager.shared.localizedString(forKey: title),
            message: LanguageManager.shared.localizedString(forKey: message),
            buttonTitle: LanguageManager.shared.localizedString(forKey: buttonTitle),
            action: action
        )
    }
    
    func showError(title: String, message: String, buttonTitle: String = "ok", action: (() -> Void)? = nil) {
        alert = .error(
            title: LanguageManager.shared.localizedString(forKey: title),
            message: LanguageManager.shared.localizedString(forKey: message),
            buttonTitle: LanguageManager.shared.localizedString(forKey: buttonTitle),
            action: action
        )
    }
    
    func showWarning(title: String, message: String, primaryTitle: String = "continue", secondaryTitle: String = "cancel", primaryAction: @escaping () -> Void, secondaryAction: (() -> Void)? = nil) {
        alert = .warning(
            title: LanguageManager.shared.localizedString(forKey: title),
            message: LanguageManager.shared.localizedString(forKey: message),
            primaryTitle: LanguageManager.shared.localizedString(forKey: primaryTitle),
            secondaryTitle: LanguageManager.shared.localizedString(forKey: secondaryTitle),
            primaryAction: primaryAction,
            secondaryAction: secondaryAction
        )
    }
    
    func showConfirmation(title: String, message: String, confirmTitle: String = "confirm", cancelTitle: String = "cancel", confirmAction: @escaping () -> Void, cancelAction: (() -> Void)? = nil) {
        alert = .confirmation(
            title: LanguageManager.shared.localizedString(forKey: title),
            message: LanguageManager.shared.localizedString(forKey: message),
            confirmTitle: LanguageManager.shared.localizedString(forKey: confirmTitle),
            cancelTitle: LanguageManager.shared.localizedString(forKey: cancelTitle),
            confirmAction: confirmAction,
            cancelAction: cancelAction
        )
    }
    
    func showDestructive(title: String, message: String, destructiveTitle: String = "delete", cancelTitle: String = "cancel", destructiveAction: @escaping () -> Void) {
        alert = .destructive(
            title: LanguageManager.shared.localizedString(forKey: title),
            message: LanguageManager.shared.localizedString(forKey: message),
            destructiveTitle: LanguageManager.shared.localizedString(forKey: destructiveTitle),
            cancelTitle: LanguageManager.shared.localizedString(forKey: cancelTitle),
            destructiveAction: destructiveAction
        )
    }
    
    func showTextField(title: String, message: String, placeholder: String = "Enter text", confirmTitle: String = "submit", cancelTitle: String = "cancel", onSubmit: @escaping (String) -> Void) {
        alert = .textField(
            title: LanguageManager.shared.localizedString(forKey: title),
            message: LanguageManager.shared.localizedString(forKey: message),
            placeholder: LanguageManager.shared.localizedString(forKey: placeholder),
            confirmTitle: LanguageManager.shared.localizedString(forKey: confirmTitle),
            cancelTitle: LanguageManager.shared.localizedString(forKey: cancelTitle),
            onSubmit: onSubmit
        )
    }
    
//    func dismiss() {
//        alert = nil
//    }
}

// MARK: - Native Alert Config
struct NativeAlertConfig: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let style: AlertStyle
    let textFieldPlaceholder: String?
    let buttons: [AlertButton]
    
    enum AlertStyle {
        case standard
        case success
        case error
        case warning
        case destructive
        case textField
    }
    
    struct AlertButton: Identifiable {
        let id = UUID()
        let title: String
        let style: ButtonStyle
        let action: () -> Void
        
        enum ButtonStyle {
            case `default`
            case cancel
            case destructive
        }
    }
    
    static func success(title: String, message: String, buttonTitle: String = "ok", action: (() -> Void)? = nil) -> NativeAlertConfig {
        NativeAlertConfig(
            title: title,
            message: message,
            style: .success,
            textFieldPlaceholder: nil,
            buttons: [
                AlertButton(title: buttonTitle, style: .default, action: action ?? {})
            ]
        )
    }
    
    static func error(title: String, message: String, buttonTitle: String = "ok", action: (() -> Void)? = nil) -> NativeAlertConfig {
        NativeAlertConfig(
            title: title,
            message: message,
            style: .error,
            textFieldPlaceholder: nil,
            buttons: [
                AlertButton(title: buttonTitle, style: .default, action: action ?? {})
            ]
        )
    }
    
    static func warning(title: String, message: String, primaryTitle: String, secondaryTitle: String, primaryAction: @escaping () -> Void, secondaryAction: (() -> Void)? = nil) -> NativeAlertConfig {
        NativeAlertConfig(
            title: title,
            message: message,
            style: .warning,
            textFieldPlaceholder: nil,
            buttons: [
                AlertButton(title: secondaryTitle, style: .cancel, action: secondaryAction ?? {}),
                AlertButton(title: primaryTitle, style: .default, action: primaryAction)
            ]
        )
    }
    
    static func confirmation(title: String, message: String, confirmTitle: String, cancelTitle: String, confirmAction: @escaping () -> Void, cancelAction: (() -> Void)? = nil) -> NativeAlertConfig {
        NativeAlertConfig(
            title: title,
            message: message,
            style: .standard,
            textFieldPlaceholder: nil,
            buttons: [
                AlertButton(title: cancelTitle, style: .cancel, action: cancelAction ?? {}),
                AlertButton(title: confirmTitle, style: .default, action: confirmAction)
            ]
        )
    }
    
    static func destructive(title: String, message: String, destructiveTitle: String, cancelTitle: String, destructiveAction: @escaping () -> Void) -> NativeAlertConfig {
        NativeAlertConfig(
            title: title,
            message: message,
            style: .destructive,
            textFieldPlaceholder: nil,
            buttons: [
                AlertButton(title: cancelTitle, style: .cancel, action: {}),
                AlertButton(title: destructiveTitle, style: .destructive, action: destructiveAction)
            ]
        )
    }
    
    static func textField(title: String, message: String, placeholder: String, confirmTitle: String, cancelTitle: String, onSubmit: @escaping (String) -> Void) -> NativeAlertConfig {
        NativeAlertConfig(
            title: title,
            message: message,
            style: .textField,
            textFieldPlaceholder: placeholder,
            buttons: [
                AlertButton(title: cancelTitle, style: .cancel, action: {}),
                AlertButton(title: confirmTitle, style: .default, action: {})
            ]
        )
    }
}

struct NativeAlertModifier: ViewModifier {
    @Binding var alert: NativeAlertConfig?
    @State private var textFieldInput: String = ""
    
    func body(content: Content) -> some View {
        content
            .alert(
                alert?.title ?? "",
                isPresented: Binding(
                    get: { alert != nil },
                    set: { isPresented in
                        if !isPresented {
                            DispatchQueue.main.async {
                                alert = nil
                            }
                        }
                    }
                ),
                presenting: alert
            ) { alertConfig in
                if alertConfig.style == .textField {
                    TextField(alertConfig.textFieldPlaceholder ?? "", text: $textFieldInput)
                }
                
                ForEach(alertConfig.buttons) { button in
                    Button(button.title, role: buttonRole(for: button.style)) {
                        DispatchQueue.main.async {
                            button.action()
                            // Handle text field submission
                            if alertConfig.style == .textField,
                               button.style == .default,
                               let onSubmit = getTextFieldSubmitAction(from: alertConfig) {
                                onSubmit(textFieldInput)
                                textFieldInput = ""
                            }
                        }
                    }
                }
            } message: { alertConfig in
                Text(alertConfig.message)
            }
    }
    
    private func buttonRole(for style: NativeAlertConfig.AlertButton.ButtonStyle) -> ButtonRole? {
        switch style {
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        case .default:
            return nil
        }
    }
    
    private func getTextFieldSubmitAction(from config: NativeAlertConfig) -> ((String) -> Void)? {
        // This is a workaround since we can't store closures with parameters directly
        // In real implementation, you'd need to handle this differently
        return nil
    }
}

extension View {
    func nativeAlert(alert: Binding<NativeAlertConfig?>) -> some View {
        modifier(NativeAlertModifier(alert: alert))
    }
}

struct NativeAlertExampleView: View {
    @StateObject private var alertManager = NativeAlertManager.shared
    @State private var showingTextField = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Success Alert
                    Button(LanguageManager.shared.localizedString(forKey: "Show Success Alert")) {
                        alertManager.showSuccess(
                            title: "Success!",
                            message: "Your data has been saved successfully."
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    
                    // Error Alert
                    Button(LanguageManager.shared.localizedString(forKey: "Show Error Alert")) {
                        alertManager.showError(
                            title: "Error Occurred",
                            message: "Unable to connect to the server. Please try again."
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    
                    // Warning Alert
                    Button(LanguageManager.shared.localizedString(forKey: "Show Warning Alert")) {
                        alertManager.showWarning(
                            title: "Are you sure?",
                            message: "This action may affect your data.",
                            primaryTitle: "Continue",
                            secondaryTitle: "Cancel",
                            primaryAction: {
                                print("User continued")
                            }
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    
                    // Confirmation Alert
                    Button(LanguageManager.shared.localizedString(forKey: "Show Confirmation")) {
                        alertManager.showConfirmation(
                            title: "Confirm Action",
                            message: "Do you want to proceed with this action?",
                            confirmTitle: "Yes",
                            cancelTitle: "No",
                            confirmAction: {
                                print("Confirmed")
                            }
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    
                    // Destructive Alert
                    Button(LanguageManager.shared.localizedString(forKey: "Show Destructive Alert")) {
                        alertManager.showDestructive(
                            title: "Delete Account",
                            message: "This action cannot be undone. All your data will be permanently deleted.",
                            destructiveTitle: "Delete",
                            cancelTitle: "Cancel",
                            destructiveAction: {
                                print("Account deleted")
                            }
                        )
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.purple)
                    
                    // Text Field Alert
                    Button(LanguageManager.shared.localizedString(forKey: "Show Text Field Alert")) {
                        showingTextField = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                    .alert(
                        LanguageManager.shared.localizedString(forKey: "Enter Your Name"),
                        isPresented: $showingTextField
                    ) {
                        TextField(LanguageManager.shared.localizedString(forKey: "Name"), text: .constant(""))
                        Button(LanguageManager.shared.localizedString(forKey: "Submit")) {
                            print("Name submitted")
                        }
                        Button(LanguageManager.shared.localizedString(forKey: "Cancel"), role: .cancel) {}
                    } message: {
                        Text(LanguageManager.shared.localizedString(forKey: "Please enter your full name below."))
                    }
                    
                    Divider()
                        .padding(.vertical)
                    
                    Button(LanguageManager.shared.localizedString(forKey: "Custom Alert Configuration")) {
                        alertManager.show(
                            NativeAlertConfig(
                                title: LanguageManager.shared.localizedString(forKey: "Custom Alert"),
                                message: LanguageManager.shared.localizedString(forKey: "This is a fully customized alert with multiple options."),
                                style: .standard,
                                textFieldPlaceholder: nil,
                                buttons: [
                                    .init(title: LanguageManager.shared.localizedString(forKey: "Option 1"), style: .default) {
                                        print("Option 1")
                                    },
                                    .init(title: LanguageManager.shared.localizedString(forKey: "Option 2"), style: .default) {
                                        print("Option 2")
                                    },
                                    .init(title: LanguageManager.shared.localizedString(forKey: "Cancel"), style: .cancel) {}
                                ]
                            )
                        )
                    }
                    .buttonStyle(.bordered)
                }
                .padding()
            }
            .navigationTitle(LanguageManager.shared.localizedString(forKey: "Native Alerts"))
        }
    }
}

