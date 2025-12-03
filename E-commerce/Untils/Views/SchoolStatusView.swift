//import SwiftUI
//import MapKit
//import CoreLocation
//
//struct RealTimeSchoolView: View {
//    @StateObject private var tracker = RealTimeSchoolTracker.shared
//    @StateObject var vm = CenterViewModel()
//    
//    @State var centerNameString = ""
//    @State var centerAddressString = ""
//    @State var latitude: Double = 11.575752
//    @State var longitude: Double = 104.889410
//    
//    @State private var position = MapCameraPosition.region(
//        MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 11.575752, longitude: 104.889410),
//            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//        )
//    )
//    
//    @State private var showEditSheet = false
//    @State private var showPermissionAlert = false
//    @State private var showCenterInputSheet = false
//    @State private var pendingLocation: CLLocationCoordinate2D?
//    
//    private var schoolCoordinate: CLLocationCoordinate2D {
//        tracker.schoolCoordinate
//    }
//    
//    private var radius: Double {
//        tracker.radius
//    }
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            ScrollView{
//                
//                Map(position: $position) {
//                    Annotation("School", coordinate: schoolCoordinate) {
//                        ZStack {
//                            Circle()
//                                .fill(Color.blue.opacity(0.2))
//                                .frame(width: CGFloat(radius * 2), height: CGFloat(radius * 2))
//                            Circle()
//                                .stroke(Color.blue.opacity(0.8), lineWidth: 2)
//                                .frame(width: CGFloat(radius * 2), height: CGFloat(radius * 2))
//                            Image(systemName: "graduationcap.fill")
//                                .foregroundColor(.blue)
//                                .font(.title)
//                        }
//                    }
//                    
//                    if let userLocation = tracker.userLocation {
//                        Annotation("You", coordinate: userLocation) {
//                            Image(systemName: "person.circle.fill")
//                                .foregroundColor(.red)
//                                .font(.title2)
//                        }
//                    }
//                }
//                .mapStyle(.standard)
//                .frame(height: 350)
//                .cornerRadius(15)
//                .padding(.horizontal)
//                
//                VStack(alignment: .leading, spacing: 8) {
//                    HStack {
//                        Text("Latitude:")
//                        Spacer()
//                        Text(String(format: "%.6f", schoolCoordinate.latitude))
//                    }
//                    
//                    HStack {
//                        Text("Longitude:")
//                        Spacer()
//                        Text(String(format: "%.6f", schoolCoordinate.longitude))
//                    }
//                    
//                    HStack {
//                        Text("Radius: \(Int(radius)) m")
//                        Spacer()
//                        Slider(value: Binding(
//                            get: { self.radius },
//                            set: { newValue in
//                                tracker.updateSchoolLocation(to: schoolCoordinate, radius: newValue)
//                            }
//                        ), in: 5...100, step: 1)
//                        .frame(width: 150)
//                    }
//                }
//                .padding()
//                .background(.ultraThinMaterial)
//                .cornerRadius(12)
//                .padding(.horizontal)
//                
//                VStack(spacing: 8) {
//                    Text("Distance to School: \(String(format: "%.2f", tracker.distanceToSchool)) m")
//                    Text(tracker.isInSchool ? "Inside School Area" : "Outside School Area")
//                        .foregroundColor(tracker.isInSchool ? .green : .red)
//                }
//                .font(.headline)
//                .padding(.top)
//                
//                Spacer()
//                
//                VStack(spacing: 10) {
//                    HStack {
//                        Button(action: { showEditSheet = true }) {
//                            Label("Edit Location", systemImage: "square.and.pencil")
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.gray.opacity(0.2))
//                                .cornerRadius(10)
//                        }
//                        
//                        Button(action: {
//                            Task {
//                                await vm.createCenter(
//                                    centerName: centerNameString,
//                                    centerAddress: centerAddressString,
//                                    longitude: longitude ,
//                                    latitude: latitude,
//                                    radius: Int(radius)
//                                )
//                            }
//                            tracker.updateSchoolLocation(to: schoolCoordinate, radius: radius)
//                            updateMapPosition()
//                        }) {
//                            Label("Apply", systemImage: "checkmark.circle.fill")
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue.gradient)
//                                .foregroundColor(.white)
//                                .cornerRadius(10)
//                        }
//                    }
//                    
//                    Button(action: {
//                        if let current = tracker.userLocation {
//                            pendingLocation = current
//                            showCenterInputSheet = true
//                        } else {
//                            showPermissionAlert = true
//                        }
//                    }) {
//                        Label("Set Current Location", systemImage: "location.fill")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.green.gradient)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                }
//                .padding(.horizontal)
//            }
//            .fullScreenCover(isPresented: $showEditSheet) {
//                EditLocationSheet(
//                    latitude: Binding(
//                        get: { self.schoolCoordinate.latitude },
//                        set: { newValue in
//                            let newCoordinate = CLLocationCoordinate2D(latitude: newValue, longitude: self.schoolCoordinate.longitude)
//                            tracker.updateSchoolLocation(to: newCoordinate, radius: self.radius)
//                        }
//                    ),
//                    longitude: Binding(
//                        get: { self.schoolCoordinate.longitude },
//                        set: { newValue in
//                            let newCoordinate = CLLocationCoordinate2D(latitude: self.schoolCoordinate.latitude, longitude: newValue)
//                            tracker.updateSchoolLocation(to: newCoordinate, radius: self.radius)
//                        }
//                    ),
//                    centerNameString: $centerNameString,
//                    centerAddressString: $centerAddressString,
//                    radius: Binding(
//                        get: { self.radius },
//                        set: { newValue in
//                            tracker.updateSchoolLocation(to: self.schoolCoordinate, radius: newValue)
//                        }
//                    )
//                )
//                .presentationDetents([.fraction(0.4)])
//            }
//            .sheet(isPresented: $showCenterInputSheet) {
//                if let location = pendingLocation {
//                    CenterInputSheet(
//                        location: location,
//                        radius: radius,
//                        onSave: { centerName, centerAddress in
//                            Task {
//                                await vm.createCenter(
//                                    centerName: centerName,
//                                    centerAddress: centerAddress,
//                                    longitude: location.longitude,
//                                    latitude: location.latitude,
//                                    radius: Int(radius)
//                                )
//                            }
//                            tracker.updateSchoolLocation(to: location, radius: radius)
//                            updateMapPosition(center: location)
//                        }
//                    )
//                }
//            }
//            .alert("Location Unavailable", isPresented: $showPermissionAlert) {
//                Button("OK", role: .cancel) {}
//            } message: {
//                Text("Unable to access your current location. Please enable location services in Settings.")
//            }
//            .onAppear {
//                updateMapPosition()
//            }
//        }
//    }
//    
//    private func updateMapPosition(center: CLLocationCoordinate2D? = nil) {
//        let centerCoordinate = center ?? schoolCoordinate
//        position = .region(
//            MKCoordinateRegion(
//                center: centerCoordinate,
//                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
//            )
//        )
//    }
//}
//
//struct IdentifiableCoordinate: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//}
//
//struct EditLocationSheet: View {
//    @Binding var latitude: Double
//    @Binding var longitude: Double
//    @Binding var centerNameString: String
//    @Binding var centerAddressString: String
//    @Binding var radius: Double
//    
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("School Location")) {
//                    HStack {
//                        Text(LanguageManager.shared.localizedString(forKey: "Center Name"))
//                        Spacer()
//                        TextField("Latitude", text: $centerNameString)
//                    }
//                    HStack {
//                        Text("Center Addrees")
//                        Spacer()
//                        TextField("Latitude", text: $centerAddressString)
//                    }
//
//                    HStack {
//                        Text("Latitude")
//                        Spacer()
//                        TextField("Latitude", value: $latitude, format: .number)
//                            .multilineTextAlignment(.trailing)
//                            .keyboardType(.decimalPad)
//                    }
//                    HStack {
//                        Text("Longitude")
//                        Spacer()
//                        TextField("Longitude", value: $longitude, format: .number)
//                            .multilineTextAlignment(.trailing)
//                            .keyboardType(.decimalPad)
//                    }
//                }
//                
//                Section(header: Text("Radius")) {
//                    HStack {
//                        Slider(value: $radius, in: 5...100, step: 1)
//                        Text("\(Int(radius)) m")
//                            .frame(width: 50)
//                    }
//                }
//            }
//            .navigationTitle("Edit School Info")
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Done") { dismiss() }
//                }
//            }
//        }
//    }
//}
//
//struct CenterInputSheet: View {
//    let location: CLLocationCoordinate2D
//    let radius: Double
//    let onSave: (String, String) -> Void
//    
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var centerName: String = ""
//    @State private var centerAddress: String = ""
//    @State private var isLoadingAddress = false
//    @State private var fetchedAddress: String = ""
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Center Information")) {
//                    TextField("Center Name", text: $centerName)
//                        .autocapitalization(.words)
//                    
//                    VStack(alignment: .leading, spacing: 8) {
//                        HStack {
//                            TextField("Center Address", text: $centerAddress, axis: .vertical)
//                                .lineLimit(2...4)
//                            
//                            if isLoadingAddress {
//                                ProgressView()
//                            }
//                        }
//                        
//                        if !fetchedAddress.isEmpty && fetchedAddress != centerAddress {
//                            Button(action: {
//                                centerAddress = fetchedAddress
//                            }) {
//                                HStack {
//                                    Image(systemName: "location.fill")
//                                        .font(.caption)
//                                    Text("Use fetched: \(fetchedAddress)")
//                                        .font(.caption)
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                        }
//                    }
//                }
//                
//                Section(header: Text("Location Details")) {
//                    HStack {
//                        Text("Latitude")
//                        Spacer()
//                        Text(String(format: "%.6f", location.latitude))
//                            .foregroundColor(.secondary)
//                    }
//                    
//                    HStack {
//                        Text("Longitude")
//                        Spacer()
//                        Text(String(format: "%.6f", location.longitude))
//                            .foregroundColor(.secondary)
//                    }
//                    
//                    HStack {
//                        Text("Radius")
//                        Spacer()
//                        Text("\(Int(radius)) m")
//                            .foregroundColor(.secondary)
//                    }
//                }
//                
//                Section {
//                    Button(action: {
//                        fetchAddress()
//                    }) {
//                        HStack {
//                            Image(systemName: "location.circle")
//                            Text("Fetch Address from Location")
//                        }
//                    }
//                    .disabled(isLoadingAddress)
//                }
//            }
//            .navigationTitle("Create Center")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        dismiss()
//                    }
//                }
//                
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Save") {
//                        onSave(centerName.isEmpty ? "New Center" : centerName,
//                               centerAddress.isEmpty ? "No address provided" : centerAddress)
//                        dismiss()
//                    }
//                    .disabled(isLoadingAddress)
//                }
//            }
//            .onAppear {
//                fetchAddress()
//            }
//        }
//    }
//    
//    private func fetchAddress() {
//        isLoadingAddress = true
//        
//        let geocoder = CLGeocoder()
//        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//        
//        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
//            isLoadingAddress = false
//            
//            if let error = error {
//                print("Geocoding error: \(error.localizedDescription)")
//                fetchedAddress = "Unable to fetch address"
//                return
//            }
//            
//            if let placemark = placemarks?.first {
//                var addressComponents: [String] = []
//                
//                if let name = placemark.name {
//                    addressComponents.append(name)
//                }
//                if let thoroughfare = placemark.thoroughfare {
//                    addressComponents.append(thoroughfare)
//                }
//                if let locality = placemark.locality {
//                    addressComponents.append(locality)
//                }
//                if let administrativeArea = placemark.administrativeArea {
//                    addressComponents.append(administrativeArea)
//                }
//                if let country = placemark.country {
//                    addressComponents.append(country)
//                }
//                
//                let address = addressComponents.joined(separator: ", ")
//                fetchedAddress = address
//                
//                if centerAddress.isEmpty {
//                    centerAddress = address
//                }
//            }
//        }
//    }
//}
