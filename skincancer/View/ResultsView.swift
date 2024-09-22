import SwiftUI

struct ResultView: View {
    let classificationResult: String
    let imageData: Data
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(10)
                }
                
                Text("Classification Result")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("🤖: \(classificationResult)")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("What is it?")
                    .font(.title)
                    .fontWeight(.bold)

                Text(specificDescription(for:classificationResult))
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("New Analysis")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .navigationTitle("Analysis Results")
    }
    private func specificDescription(for result: String) -> String {
        print(result)
        if result.contains("Melanocytic nevi") {
            return "Melanocytic nevi are benign proliferations of melanocytes, the cells responsible for producing pigment in the skin. Commonly referred to as moles, these nevi are usually harmless but can vary in appearance from flat to raised, and from skin-colored to dark brown. Monitoring moles for changes in size, shape, or color is important, as these could be early signs of melanoma."
            
        } else if result.contains("dermatofibroma") || result.contains("Dermatofibroma") {
            return "Dermatofibroma is a common benign skin growth that often appears on the lower legs, though it can occur anywhere on the body. These growths are typically firm to the touch, slightly raised, and darker than the surrounding skin. Dermatofibromas are usually harmless and do not require treatment unless they cause discomfort or cosmetic concerns."
            
        } else if result.contains("Benign") {
            return "Benign keratosis-like lesions, also known as seborrheic keratoses, are non-cancerous skin growths that often appear as wart-like, waxy, or scaly patches. They can be brown, black, or tan and are commonly found on the face, chest, shoulders, or back. While these lesions are benign, they can sometimes be mistaken for skin cancer, so a professional evaluation may be recommended if there are concerns."
            
        } else if result.contains("Basal cell carcinoma") {
            return "Basal cell carcinoma (BCC) is the most common type of skin cancer, primarily caused by prolonged exposure to ultraviolet (UV) radiation from the sun. BCCs typically appear as pearly or waxy bumps, often with visible blood vessels, or as flat, flesh-colored lesions. While BCCs are usually slow-growing and rarely metastasize, they can cause significant local damage if not treated. Treatment options include surgical excision, Mohs surgery, and topical therapies."
            
        } else if result.contains("Actinic keratoses") {
            return "Actinic keratoses are rough, scaly patches that develop on sun-exposed areas of the skin, such as the face, ears, neck, scalp, chest, hands, and forearms. These lesions are considered precancerous, as they can progress to squamous cell carcinoma if left untreated. Treatment often involves cryotherapy, topical medications, or photodynamic therapy to prevent progression to cancer."
            
        } else if result.contains("Vascular lesions") {
            return "Vascular lesions are a broad category of abnormalities related to blood vessels that manifest on the skin. These can include conditions like hemangiomas, port-wine stains, and spider veins. Vascular lesions can be congenital (present at birth) or acquired later in life. Treatment options depend on the type and location of the lesion and may include laser therapy, sclerotherapy, or observation if the lesion is not causing symptoms."
            
        }else if result.contains("Melanoma") {
                return "Melanoma is the most dangerous form of skin cancer, originating from the melanocytes, which are the cells that produce pigment in the skin. It often presents as a new mole or a change in an existing mole, following the ABCDE rule: Asymmetry, Border irregularity, Color variation, Diameter larger than 6mm, and Evolving shape or color. Early detection is critical, as melanoma can spread to other parts of the body if not caught early. Treatment options may include surgical removal, immunotherapy, targeted therapy, or radiation, depending on the stage of the disease."

        } else {
            return "This is a less common diagnosis. Please consult with your healthcare provider for more information and to discuss appropriate management and treatment options tailored to your specific condition."
        }
    }
}
