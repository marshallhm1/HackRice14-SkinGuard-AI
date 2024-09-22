import SwiftUI
import PhotosUI
import SwiftData
import AVFoundation
import CoreML
import Vision

extension CIImage {
    func resizedAndCropped(to size: CGSize) -> CIImage {
        let scale = min(size.width / extent.width, size.height / extent.height)
        let scaledImage = transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        let centerX = (scaledImage.extent.width - size.width) / 2
        let centerY = (scaledImage.extent.height - size.height) / 2
        return scaledImage.cropped(to: CGRect(x: centerX, y: centerY, width: size.width, height: size.height))
    }
}

struct CameraView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var classificationResult: String = ""
    @State private var isAnalyzing: Bool = false
    @State private var showingResult: Bool = false
    @State private var showingCamera: Bool = false
    
    // Load the Core ML model
    let model: VNCoreMLModel = {
        do {
            let config = MLModelConfiguration()
            let model = try SkinCancerDetection(configuration: config)
            return try VNCoreMLModel(for: model.model)
        } catch {
            fatalError("Failed to load Core ML model: \(error)")
        }
    }()
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(spacing: 30) {
                    VStack(spacing: 15) {
                        Text("Image Guidelines")
                            .font(.system(size: 26, weight: .semibold, design: .rounded))
                            .foregroundColor(.charcoal)
                        
                        Text("Your image should be:")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundColor(.slateGray)
                        
                        VStack(alignment: .leading, spacing: 17) {
                            GuidelineRow(text: "Bright and well-lit")
                            GuidelineRow(text: "A close-up of the affected area")
                            GuidelineRow(text: "In focus and clear")
                        }
                    }
                    .padding()
                    .background(Color.timberwolf)
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            self.showingCamera = true
                        }) {
                            Text("Take a Photo")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.charcoal)
                                .cornerRadius(10)
                        }
                        
                        PhotosPicker(selection: $selectedItem, matching: .images) {
                            Text("Upload Photo")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.oldGold)
                                .cornerRadius(10)
                        }
                        .onChange(of: selectedItem) { oldValue, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                    await MainActor.run {
                                        selectedImageData = data
                                        classifyImage()
                                    }
                                } else {
                                    print("Failed to load image data")
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                VStack {
                    Text("Remember that results are simply an estimate, and the actual diagnosis may vary depending on the quality of your image. Results should not be a substitute for medical advice.")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.slateGray)
                }
                .padding(.bottom, 10)
                
                if isAnalyzing {
                    ProgressView("Analyzing...")
                        .padding()
                        .background(Color.timberwolf)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                
                NavigationLink(destination: ResultView(classificationResult: classificationResult, imageData: selectedImageData ?? Data()), isActive: $showingResult) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("Upload an Image")
            .sheet(isPresented: $showingCamera) {
                ImagePicker(selectedImage: $selectedImageData, sourceType: .camera)
            }
            .onChange(of: selectedImageData) { oldValue, newValue in
                if newValue != nil {
                    classifyImage()
                }
            }
        }
    }
    
    
    private func classifyImage() {
        guard let imageData = selectedImageData, let ciImage = CIImage(data: imageData) else {
            print("Failed to create CIImage from selectedImageData")
            classificationResult = "Failed to process the image"
            return
        }

        isAnalyzing = true
        classificationResult = ""

        // Preprocess the image
        let modelInputSize = CGSize(width: 224, height: 224) // Adjust this to match your model's expected input size
        let preprocessedImage = ciImage.resizedAndCropped(to: modelInputSize)

        let handler = VNImageRequestHandler(ciImage: preprocessedImage, orientation: .up)
        let request = VNCoreMLRequest(model: model) { request, error in
            isAnalyzing = false
            if let error = error {
                print("VNCoreMLRequest error: \(error)")
                self.classificationResult = "Classification error: \(error.localizedDescription)"
                self.showingResult = true
                return
            }
            
            guard let firstResult = request.results?.first as? VNClassificationObservation else {
                self.classificationResult = "No results found or unexpected result type"
                self.showingResult = true
                return
            }

            
            let predictedClassIdentifier = firstResult.identifier.trimmingCharacters(in: .whitespacesAndNewlines)
            

            // Mapping from class identifiers to cancer type
            let classMapping: [String: String] = [
                "class1": "Melanocytic nevi",
                "class2": "Melanoma",
                "class3": "Benign keratosis-like lesions",
                "class4": "Basal cell carcinoma",
                "class5": "Actinic keratoses",
                "class6": "Vascular lesions",
                "class7": "Dermatofibroma"
            ]
            
            


            
            let predictedClassName = classMapping[predictedClassIdentifier] ?? "Unknown class"

            // Save only the mapped class name
            self.classificationResult = predictedClassName
            
            print("Predicted class: \(predictedClassName)")

            saveClassificationResult(self.classificationResult, imageData: imageData)
            self.showingResult = true
        }

        do {
            try handler.perform([request])
        } catch {
            isAnalyzing = false
            print("Failed to perform classification: \(error)")
            classificationResult = "Failed to perform classification: \(error.localizedDescription)"
            showingResult = true
        }
    }



    
    private func saveClassificationResult(_ result: String, imageData: Data) {
        let newReport = Report(imageData: imageData, result: result, date: Date(), journalEntry: "")
        modelContext.insert(newReport)
        
        do {
            try modelContext.save()
        } catch {
            print("Error saving report: \(error)")
        }
    }
}

struct GuidelineRow: View {
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(text)
                .font(.system(size: 22, weight: .regular, design: .rounded))
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: Data?
    let sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image.jpegData(compressionQuality: 1.0)
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
