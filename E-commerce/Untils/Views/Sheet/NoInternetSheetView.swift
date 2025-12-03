//
//import SwiftUI
//
//struct NoInternetSheetView: View {
//    @ObservedObject var networkMonitor: NetworkMonitor
//    @Binding var isPresented: Bool
//    
//    var body: some View {
//        VStack(spacing: 24) {
//            Spacer()
//            ZStack {
//                Circle()
//                    .fill(Color.red.opacity(0.1))
//                    .frame(width: 100, height: 100)
//                
//                Image(systemName: "wifi.slash")
//                    .font(.system(size: 50))
//                    .foregroundColor(.red)
//            }
//            .padding(.top, 12)
//            
//            Text("No Internet Connection")
//                .font(.title2)
//                .fontWeight(.bold)
//                .foregroundColor(.primary)
//            
//            Text("Please check your network settings and make sure you're connected to WiFi or mobile data.")
//                .font(.body)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 32)
//            
//            if !networkMonitor.isConnected {
//                HStack(spacing: 8) {
//                    Image(systemName: "antenna.radiowaves.left.and.right.slash")
//                        .foregroundColor(.orange)
//                    Text("Connection lost")
//                        .font(.subheadline)
//                        .foregroundColor(.orange)
//                }
//                .padding(.horizontal, 16)
//                .padding(.vertical, 8)
//                .background(Color.orange.opacity(0.1))
//                .cornerRadius(8)
//            }
//            
//            VStack(spacing: 12) {
//                
//                PrimaryButton(title: "try_again", icon: "arrow.clockwise", shadow: 0, action: {
//                    if networkMonitor.isConnected {
//                        isPresented = false
//                    }
//                })
//                PrimaryButton(title: "open_setting", icon: "gear", backgroundColor: Color.gray.opacity(0.2), textColor: .prime, shadow: 0, action: {
//                    openSettings()
//                })
//                
//                PrimaryButton(title: "dismiss", backgroundColor: Color.clear, textColor: .secondary, shadow: 0,action: {
//                    isPresented = false
//                })
//                .padding(.vertical, 8)
//                Spacer()
//            }
//            .padding(.horizontal, 24)
//        }
//        .presentationDragIndicator(.visible)
//        .presentationDetents([.fraction(0.7), .large])
//        .onChange(of: networkMonitor.isConnected) { _, isConnected in
//            // Auto-dismiss when connection is restored
//            if isConnected {
//                isPresented = false
//            }
//        }
//    }
//    
//    // Open device settings
//    private func openSettings() {
//        if let url = URL(string: UIApplication.openSettingsURLString) {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//            }
//        }
//    }
//}
//
//// MARK: - Alternative Compact Design
//struct NoInternetSheetCompact: View {
//    @ObservedObject var networkMonitor: NetworkMonitor
//    @Binding var isPresented: Bool
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            HStack {
//                Image(systemName: "wifi.slash")
//                    .font(.title2)
//                    .foregroundColor(.red)
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(LanguageManager.shared.localizedString(forKey: "no_internet"))
//                        .font(.custom(LanguageManager.shared.getFont(), size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
//                        .font(.headline)
//                    Text("check_your_connection")
//                        .font(.custom(LanguageManager.shared.getFont(), size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
//                        .font(.subheadline)
//                }
//                
//                Spacer()
//                
////                Button(action: {
////                    isPresented = false
////                }) {
////                    Image(systemName: "xmark.circle.fill")
////                        .font(.title2)
////                        .foregroundColor(.gray)
////                }
//            }
//            .padding(.horizontal)
//            .padding(.top, 20)
//            
//            Divider()
//            
//            VStack(spacing: 12) {
//                PrimaryButton(title: "try_again", icon: "arrow.clockwise", action: {
//                    if networkMonitor.isConnected {
//                        isPresented = false
//                    }
//                })
//                PrimaryButton(title: "open_setting", icon: "gear", backgroundColor: Color.gray.opacity(0.2), textColor: .prime, action: {
//                    openSettings()
//                })
//            }
//            .padding(.horizontal)
//            .padding(.bottom, 20)
//        }
//        .presentationDetents([.large])
//        .presentationDragIndicator(.visible)
//        .onChange(of: networkMonitor.isConnected) { _, isConnected in
//            if isConnected {
//                isPresented = false
//            }
//        }
//    }
//    
//    private func openSettings() {
//        if let url = URL(string: UIApplication.openSettingsURLString) {
//            if UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//            }
//        }
//    }
//}
