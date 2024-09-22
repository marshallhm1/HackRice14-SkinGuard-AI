import SwiftUI
import MapKit
import CoreLocation

struct DoctorSearchView: View {
    @StateObject private var viewModel = DoctorSearchViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // MapView
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.nearbyDoctors) { doctor in
                MapAnnotation(coordinate: doctor.location) {
                    DoctorAnnotationView(doctor: doctor, action: {
                        viewModel.selectedDoctor = doctor
                    })
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            // Draggable Drawer
            VStack(spacing: 10) {
                Capsule()
                    .frame(width: 40, height: 5)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                
                Text("Nearby Dermatologists")
                    .font(.headline)
                    .padding(.top, 5)
                
                if viewModel.isLoading {
                    ProgressView("Searching...")
                } else if viewModel.nearbyDoctors.isEmpty {
                    Text("No dermatologists found nearby")
                        .foregroundColor(.secondary)
                } else {
                    List(viewModel.nearbyDoctors) { doctor in
                        DoctorListItemView(doctor: doctor, action: {
                            viewModel.selectedDoctor = doctor
                        })
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.4)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 10)
            .offset(y: viewModel.isDrawerOpen ? 0 : UIScreen.main.bounds.height * 0.3)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation {
                            viewModel.isDrawerOpen = value.translation.height < 0
                        }
                    }
            )
        }
        .sheet(item: $viewModel.selectedDoctor) { doctor in
            DoctorDetailView(doctor: doctor)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct DoctorAnnotationView: View {
    let doctor: Doctor
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "stethoscope")
                .foregroundColor(.white)
                .padding(8)
                .background(Color.blue)
                .clipShape(Circle())
        }
    }
}

struct DoctorListItemView: View {
    let doctor: Doctor
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading) {
                Text(doctor.name)
                    .font(.headline)
                Text(doctor.specialty)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 5)
        }
    }
}

struct DoctorDetailView: View {
    let doctor: Doctor
    @State private var region: MKCoordinateRegion
    @Environment(\.dismiss) private var dismiss
    
    init(doctor: Doctor) {
        self.doctor = doctor
        _region = State(initialValue: MKCoordinateRegion(
            center: doctor.location,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(doctor.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(doctor.specialty)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                }
                .padding(.bottom)
                
                // Map
                Map(coordinateRegion: $region, annotationItems: [doctor]) { doctor in
                    MapMarker(coordinate: doctor.location, tint: .blue)
                }
                .frame(height: 200)
                .cornerRadius(10)
                
                // Contact Information
                GroupBox(label: Label("Contact Information", systemImage: "person.crop.circle.fill")) {
                    VStack(alignment: .leading, spacing: 10) {
                        InfoRow(icon: "mappin.circle.fill", text: doctor.address)
                        InfoRow(icon: "phone.fill", text: doctor.phone)
                        if let email = doctor.email {
                            InfoRow(icon: "envelope.fill", text: email)
                        }
                        if let website = doctor.website {
                            Link(destination: URL(string: website)!) {
                                InfoRow(icon: "globe", text: "Visit Website")
                            }
                        }
                    }
                }
                
                // Hours of Operation
                if let hours = doctor.hoursOfOperation {
                    GroupBox(label: Label("Hours of Operation", systemImage: "clock.fill")) {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(hours.sorted(by: { $0.key < $1.key }), id: \.key) { day, hours in
                                Text("\(day): \(hours)")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                
                // Services Offered
                if let services = doctor.servicesOffered {
                    GroupBox(label: Label("Services Offered", systemImage: "list.bullet.clipboard.fill")) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(services, id: \.self) { service in
                                    Text(service)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }
                }
                
                // Action Buttons
                VStack(spacing: 10) {
                    Button(action: {
                        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: doctor.location))
                        mapItem.name = doctor.name
                        mapItem.openInMaps(launchOptions: nil)
                    }) {
                        Label("Open in Maps", systemImage: "map.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button(action: {
                        guard let url = URL(string: "tel://\(doctor.phone.replacingOccurrences(of: " ", with: ""))") else { return }
                        UIApplication.shared.open(url)
                    }) {
                        Label("Call Doctor", systemImage: "phone.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .font(.subheadline)
        }
    }
}

class DoctorSearchViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Published var nearbyDoctors: [Doctor] = []
    @Published var isDrawerOpen = false
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var selectedDoctor: Doctor?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        locationManager.stopUpdatingLocation()
        searchNearbyDoctors()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        alertMessage = "Failed to get your location: \(error.localizedDescription)"
        showAlert = true
    }
    
    private func searchNearbyDoctors() {
        isLoading = true
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "dermatologist"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                self.alertMessage = "Search failed: \(error.localizedDescription)"
                self.showAlert = true
                return
            }
            
            guard let response = response else {
                self.alertMessage = "No results found"
                self.showAlert = true
                return
            }
            
            self.nearbyDoctors = response.mapItems.map { item in
                Doctor(
                    name: item.name ?? "Unknown",
                    specialty: "Dermatologist",
                    location: item.placemark.coordinate,
                    address: item.placemark.title ?? "Unknown address",
                    phone: item.phoneNumber ?? "No phone number available",
                    email: nil,
                    website: nil,
                    hoursOfOperation: nil,
                    servicesOffered: nil
                )
            }
        }
    }
}

struct Doctor: Identifiable {
    let id = UUID()
    let name: String
    let specialty: String
    let location: CLLocationCoordinate2D
    let address: String
    let phone: String
    let email: String?
    let website: String?
    let hoursOfOperation: [String: String]?
    let servicesOffered: [String]?
}

struct DoctorSearchView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorSearchView()
    }
}


