//import SwiftUI
//import Combine
//import PhotosUI
//import UIKit
//
//struct EditorView: View {
//    @State var selectedItem: PhotosPickerItem?
//    @State var selectImage: UIImage?
//    var imageUrl: String?
//    @State var choosingPhoto: Bool = false
//    @StateObject var updateProfileViewModel: UploadFileImageViewModel = UploadFileImageViewModel()
//    @EnvironmentObject var profileViewModel: ProfileAdminViewModel
//    
//    @State private var showingCamera: Bool = false
//    @State private var isSeePicture: Bool = false
//    
//    @State private var imageToCrop: UIImage?
//    @State private var showCropView: Bool = false
//    
//    var body: some View {
//        VStack{
//            if updateProfileViewModel.isLoading {
//                SkeletonView(shape: Circle())
//                    .frame(width: 65, height: 65)
//            }else if let selectImage = selectImage{
//                ZStack{
//                    Image(uiImage: selectImage)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 65, height: 65)
//                        .overlay{
//                            RoundedRectangle(cornerRadius: 100)
//                                .stroke(Color.white, lineWidth: 2)
//                        }
//                        .clipShape(RoundedRectangle(cornerRadius: 100))
//                    VStack{
//                        Image(systemName: "camera")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 12, height: 12)
//                            .foregroundStyle(Color.black)
//                            .onTapGesture {
//                                choosingPhoto = true
//                            }
//                    }
//                    .padding(5)
//                    .background(Color.white)
//                    .cornerRadius(100)
//                    .offset(x: 22, y: 22)
//                }
//            }else{
//                UserProfile(imageUrl: imageUrl ?? "", choosingPhoto: $choosingPhoto)
//            }
//        }
//        .onTapGesture {
//            isSeePicture.toggle()
//        }
//        .shadow(radius: 2)
//        .fullScreenCover(isPresented: $isSeePicture){
//            PreviewProfilePicture(imageURL: imageUrl ?? "")
//                .environmentObject(updateProfileViewModel)
//        }
//        .sheet(isPresented: $choosingPhoto){
//            VStack(alignment: .leading, spacing: 16){
//                PrimaryButton(title: "Take photo", backgroundColor: Color.clear, textColor: Color.prime, shadow: 0, border: Color.secon){
//                    showingCamera = true
//                }
//                .fullScreenCover(isPresented: $showingCamera, content: {
//                    CameraView(image: $imageToCrop)
//                        .environmentObject(updateProfileViewModel)
//                        .ignoresSafeArea(.all)
//                })
//                PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()){
//                    Text(LanguageManager.shared.localizedString(forKey: "Select photo"))
//                        .font(.custom(LanguageManager.shared.getFont(), size: UIFont.preferredFont(forTextStyle: .headline).pointSize))
//                        .padding(.vertical, 12)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                }
//            }
//            .padding()
//            .padding(.top, 8)
//            .presentationCornerRadius(24)
//            .presentationDetents([.fraction(0.3), .medium])
//            .presentationDragIndicator(.visible)
//            Spacer()
//        }
//        .fullScreenCover(isPresented: $showCropView) {
//            if let image = imageToCrop {
//                ImageCropView(
//                    image: image,
//                    onCrop: { croppedImage in
//                        selectImage = croppedImage
//                        imageToCrop = nil
//                        showCropView = false
//                        
//                        Task {
//                            await updateProfileViewModel.uploadProfileImage(croppedImage)
//                            profileViewModel.hasLoad = false
//                            if let errorMessage = updateProfileViewModel.errorMessage {
//                                print("error: \(errorMessage)")
//                            }
//                        }
//                    },
//                    onCancel: {
//                        imageToCrop = nil
//                        showCropView = false
//                    }
//                )
//            }
//        }
//        .onChange(of: selectedItem) { previous, current in
//            guard let newItem = current else { return }
//            Task {
//                if let data = try? await newItem.loadTransferable(type: Data.self),
//                   let image = UIImage(data: data) {
//                    await MainActor.run {
//                        imageToCrop = image
//                        selectedItem = nil
//                        choosingPhoto = false
//                        showCropView = true
//                    }
//                }
//            }
//        }
//        .onChange(of: imageToCrop) { oldValue, newValue in
//            print("imageToCrop changed: \(newValue != nil ? "Has image" : "No image")")
//            if newValue != nil && !showingCamera {
//                choosingPhoto = false
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                    showCropView = true
//                    print("Showing crop view")
//                }
//            }
//        }
//        .onChange(of: showingCamera) { oldValue, newValue in
//            print("🔄 showingCamera changed: \(oldValue) -> \(newValue)")
//            if !newValue && imageToCrop != nil {
//                print("⏰ Camera closed with image, waiting to show crop...")
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    print("Now showing crop view")
//                    showCropView = true
//                }
//            }
//        }
//    }
//}
//
//struct ImageCropView: View {
//    let image: UIImage
//    let onCrop: (UIImage) -> Void
//    let onCancel: () -> Void
//    
//    @State private var scale: CGFloat = 1.0
//    @State private var lastScale: CGFloat = 1.0
//    @State private var offset: CGSize = .zero
//    @State private var lastOffset: CGSize = .zero
//    
//    private let minScale: CGFloat = 1.0
//    private let maxScale: CGFloat = 3.0
//    
//    var body: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
//            
//            VStack(spacing: 0) {
//                // Header
//                HStack {
//                    Button(action: onCancel) {
//                        Text("Cancel")
//                            .foregroundColor(.white)
//                            .padding()
//                    }
//                    
//                    Spacer()
//                    
//                    Text("Move and Scale")
//                        .foregroundColor(.white)
//                        .font(.headline)
//                    
//                    Spacer()
//                    
//                    Button(action: cropImage) {
//                        Text("Done")
//                            .foregroundColor(.blue)
//                            .fontWeight(.semibold)
//                            .padding()
//                    }
//                }
//                .frame(height: 50)
//                .background(Color.black)
//                .zIndex(10)
//                
//                Spacer()
//                
//                // Crop Area
//                GeometryReader { geometry in
//                    let size = geometry.size
//                    let cropSize = min(size.width, size.height) * 0.75
//                    
//                    ZStack {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .scaleEffect(scale)
//                            .offset(offset)
//                            .frame(width: size.width, height: size.height)
//                            .clipped()
//                        
//                        ZStack {
//                            Rectangle()
//                                .fill(Color.black.opacity(0.5))
//                                .frame(width: size.width, height: size.height)
//                            
//                            Circle()
//                                .frame(width: cropSize, height: cropSize)
//                                .blendMode(.destinationOut)
//                        }
//                        .compositingGroup()
//                        .allowsHitTesting(false)
//                        
//                        Circle()
//                            .stroke(Color.white, lineWidth: 2)
//                            .frame(width: cropSize, height: cropSize)
//                            .allowsHitTesting(false)
//                    
//                        Circle()
//                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
//                            .frame(width: cropSize * 0.66, height: cropSize * 0.66)
//                            .allowsHitTesting(false)
//                        
//                        Circle()
//                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
//                            .frame(width: cropSize * 0.33, height: cropSize * 0.33)
//                            .allowsHitTesting(false)
//                    }
//                    .frame(width: size.width, height: size.height)
//                    .clipped()
//                    .gesture(
//                        MagnificationGesture()
//                            .onChanged { value in
//                                let delta = value / lastScale
//                                lastScale = value
//                                scale = min(max(scale * delta, minScale), maxScale)
//                            }
//                            .onEnded { _ in
//                                lastScale = 1.0
//                            }
//                    )
//                    .simultaneousGesture(
//                        DragGesture()
//                            .onChanged { value in
//                                offset = CGSize(
//                                    width: lastOffset.width + value.translation.width,
//                                    height: lastOffset.height + value.translation.height
//                                )
//                            }
//                            .onEnded { _ in
//                                lastOffset = offset
//                            }
//                    )
//                }
//                .frame(maxHeight: .infinity)
//                
//                Spacer()
//                
//                VStack(spacing: 20) {
//                    HStack {
//                        Text("Zoom")
//                            .foregroundColor(.white)
//                            .font(.subheadline)
//                        Slider(value: $scale, in: minScale...maxScale)
//                            .accentColor(.blue)
//                    }
//                    .padding(.horizontal, 30)
//                    
//                    HStack(spacing: 30) {
//                        Button(action: resetTransform) {
//                            VStack(spacing: 4) {
//                                Image(systemName: "arrow.counterclockwise")
//                                    .font(.system(size: 20))
//                                Text("Reset")
//                                    .font(.caption2)
//                            }
//                            .foregroundColor(.white)
//                            .frame(width: 60, height: 60)
//                            .background(Color.white.opacity(0.2))
//                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                        }
//                        
//                        Button(action: { withAnimation { scale = min(scale + 0.2, maxScale) } }) {
//                            Image(systemName: "plus.magnifyingglass")
//                                .font(.system(size: 24))
//                                .foregroundColor(.white)
//                                .frame(width: 60, height: 60)
//                                .background(Color.white.opacity(0.2))
//                                .clipShape(Circle())
//                        }
//                        
//                        Button(action: { withAnimation { scale = max(scale - 0.2, minScale) } }) {
//                            Image(systemName: "minus.magnifyingglass")
//                                .font(.system(size: 24))
//                                .foregroundColor(.white)
//                                .frame(width: 60, height: 60)
//                                .background(Color.white.opacity(0.2))
//                                .clipShape(Circle())
//                        }
//                    }
//                }
//                .padding(.bottom, 40)
//                .background(Color.black)
//                .zIndex(10)
//            }
//        }
//    }
//    
//    private func resetTransform() {
//        withAnimation(.spring(response: 0.3)) {
//            scale = 1.0
//            offset = .zero
//            lastOffset = .zero
//        }
//    }
//    
//    private func cropImage() {
//        let imageSize = image.size
//        let screenSize = UIScreen.main.bounds.size
//        
//        let cropDiameter = min(screenSize.width, screenSize.height) * 0.75
//        let scaleFactor = imageSize.width / screenSize.width
//        let scaledCropDiameter = cropDiameter * scaleFactor / scale
//        
//        let centerX = imageSize.width / 2 - (offset.width * scaleFactor / scale)
//        let centerY = imageSize.height / 2 - (offset.height * scaleFactor / scale)
//        
//        let x = max(0, centerX - scaledCropDiameter / 2)
//        let y = max(0, centerY - scaledCropDiameter / 2)
//        let width = min(scaledCropDiameter, imageSize.width - x)
//        let height = min(scaledCropDiameter, imageSize.height - y)
//        
//        let cropRect = CGRect(x: x, y: y, width: width, height: height)
//        
//        if let cgImage = image.cgImage?.cropping(to: cropRect) {
//            let croppedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
//            onCrop(croppedImage)
//        }
//    }
//}
//
//struct PreviewProfilePicture: View {
//    @Environment(\.dismiss) var dismiss
//    @Environment(\.colorScheme) var colorScheme
//    var imageURL: String = ""
//    
//    @State private var scale: CGFloat = 1.0
//    @State private var lastScale: CGFloat = 1.0
//    @State private var offset: CGSize = .zero
//    @State private var lastOffset: CGSize = .zero
//    
//    private let minScale: CGFloat = 1.0
//    private let maxScale: CGFloat = 4.0
//    
//    @EnvironmentObject var updateProfileViewModel: UploadFileImageViewModel
//    
//    var body: some View {
//        VStack{
//            HStack{
//                Button(action: {
//                    withAnimation{
//                        dismiss()
//                    }
//                }, label: {
//                    Image(systemName: "xmark")
//                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
//                })
//                .buttonStyle(CustomButtonStyle())
//                .padding()
//                Spacer()
//            }
//            .padding(.top)
//            .opacity(scale > 1 ? 0 : 1)
//            .animation(.easeInOut(duration: 0.2), value: scale)
//            
//            Spacer()
//            
//            HStack{
//                KFImageView(
//                    imageUrl: (updateProfileViewModel.urlImage != nil ? updateProfileViewModel.urlImage : imageURL) ?? "http://96.9.81.187:9091/api/v1/files/preview-file/670f6152-05ea-49bd-a4e8-af4282c22cd7.jpg",
//                    cornerRadius: 0,
//                    fillContainer: true
//                )
//                .scaleEffect(scale)
//                .offset(offset)
//                .gesture(
//                    MagnificationGesture()
//                        .onChanged { value in
//                            let delta = value / lastScale
//                            lastScale = value
//                            scale = min(max(scale * delta, minScale), maxScale)
//                        }
//                        .onEnded { _ in
//                            lastScale = 1.0
//                            withAnimation(.spring(response: 0.3)) {
//                                if scale < minScale {
//                                    scale = minScale
//                                    offset = .zero
//                                    lastOffset = .zero
//                                } else {
//                                    validateOffset()
//                                }
//                            }
//                        }
//                )
//                .simultaneousGesture(
//                    DragGesture()
//                        .onChanged { value in
//                            guard scale > 1 else { return }
//                            offset = CGSize(
//                                width: lastOffset.width + value.translation.width,
//                                height: lastOffset.height + value.translation.height
//                            )
//                        }
//                        .onEnded { _ in
//                            withAnimation(.spring(response: 0.3)) {
//                                validateOffset()
//                                lastOffset = offset
//                            }
//                        }
//                )
//                .onTapGesture(count: 2) {
//                    withAnimation(.spring(response: 0.3)) {
//                        if scale > 1 {
//                            scale = 1
//                            offset = .zero
//                            lastOffset = .zero
//                        } else {
//                            scale = 2.5
//                        }
//                    }
//                }
//            }
//            .frame(maxHeight: 300)
//            
//            Spacer()
//        }
//        .contentShape(Rectangle())
//    }
//    
//    private func validateOffset() {
//        let imageWidth: CGFloat = UIScreen.main.bounds.width
//        let imageHeight: CGFloat = 300
//        
//        let maxOffsetX = (imageWidth * (scale - 1)) / 2
//        let maxOffsetY = (imageHeight * (scale - 1)) / 2
//        
//        offset.width = min(max(offset.width, -maxOffsetX), maxOffsetX)
//        offset.height = min(max(offset.height, -maxOffsetY), maxOffsetY)
//        
//        if scale <= 1 {
//            offset = .zero
//            lastOffset = .zero
//        }
//    }
//}
//
//struct CameraView: UIViewControllerRepresentable {
//    @EnvironmentObject var updateProfileViewModel: UploadFileImageViewModel
//    @Binding var image: UIImage?
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.delegate = context.coordinator
//        picker.sourceType = .camera
//        picker.allowsEditing = false
//        picker.cameraCaptureMode = .photo
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//        let parent: CameraView
//
//        init(_ parent: CameraView) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//            print("📸 Camera captured image")
//            if let image = info[.originalImage] as? UIImage {
//                print("Image found: \(image.size)")
//                DispatchQueue.main.async {
//                    self.parent.image = image
//                    print("Image set to binding")
//                }
//            } else {
//                print("No image found in info")
//            }
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            print("Camera cancelled")
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//    }
//}
