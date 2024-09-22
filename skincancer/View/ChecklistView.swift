import SwiftUI

struct ChecklistView: View {
    @State private var checklistItems = [
        ChecklistItem(title: "Apply Sunscreen 🧴", isChecked: false),
        ChecklistItem(title: "Wear a Hat 🎩", isChecked: false),
        ChecklistItem(title: "Seek Shade ⛱️", isChecked: false)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach($checklistItems) { $item in
                HStack {
                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(item.isChecked ? .green : .gray)
                        .onTapGesture {
                            item.isChecked.toggle()
                        }
                    
                    Text(item.title)
                        .font(.headline)
                        .foregroundColor(item.isChecked ? .gray : .primary)
                        .strikethrough(item.isChecked)
                    
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.systemGray6))
                        .shadow(radius: 5)
                )
            }
        }
        .padding()
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ChecklistItem: Identifiable {
    let id = UUID()
    var title: String
    var isChecked: Bool
}

struct ChecklistView_Previews: PreviewProvider {
    static var previews: some View {
        ChecklistView()
    }
}
