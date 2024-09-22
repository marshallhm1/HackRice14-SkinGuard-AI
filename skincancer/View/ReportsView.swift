import SwiftUI
import SwiftData

struct ReportsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var reports: [Report]
    @State private var selectedReport: Report?
    
    var body: some View {
        NavigationView {
            VStack(alignment:.leading, spacing: 0){
                HStack{
                    Text("Your Report History")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.charcoal)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 15)
                List {
                    ForEach(reports.sorted(by: { $0.date > $1.date })) { report in
                        Result(report: report)
                            .listRowSeparator(.hidden)
                            .background(Color(.systemBackground)) // Use system background color
                        
                            .onTapGesture {
                                selectedReport = report
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteReport(report)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(Color.red) 
                            }
                    }
                }
                .navigationTitle("")
                .navigationBarHidden(true)
                .sheet(item: $selectedReport) { report in
                    ReportDetailView(report: report)
                }
                .background(Color(.systemBackground)) // Use system background color
                .scrollContentBackground(.hidden)
            }
        }
    }
    
    private func deleteReport(_ report: Report) {
        modelContext.delete(report)
        do {
            try modelContext.save()
        } catch {
            print("Error deleting report: \(error)")
        }
    }
}

struct ReportDetailView: View {
    let report: Report
    @State private var journalEntry: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Image Section
                if let uiImage = UIImage(data: report.imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                        .padding(.horizontal)
                }
                
                // Report Details Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Classification Result")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.charcoal)
                    
                    Text(report.result)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.slateGray)
                    
                    Divider()
                    
                    Text("Date")
                        .font(.headline)
                        .foregroundColor(.charcoal)
                    
                    Text(report.date, style: .date)
                        .font(.body)
                        .foregroundColor(.slateGray)
                    Text("Information")
                        .font(.headline)
                        .foregroundColor(.charcoal)
                    Text(specificDescription(for:report.result))
                }
                .padding()
                .background(Color.timberwolf.opacity(0.2))
                .cornerRadius(15)
                .shadow(radius: 5)
                .padding(.horizontal)
                
                // Journal Entry Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Journal")
                        .font(.headline)
                        .foregroundColor(.charcoal)
                    
                    TextEditor(text: $journalEntry)
                        .frame(height: 150)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.cadetGray, lineWidth: 1)
                        )
                        .shadow(radius: 2)
                }
                .padding(.horizontal)
            }
            .padding(.top, 30)
            .padding(.bottom, 50)
        }
        .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
        .navigationTitle("Report Details")
        .navigationBarTitleDisplayMode(.inline)
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





