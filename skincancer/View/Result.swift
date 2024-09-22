import SwiftUI

struct Result: View {
    var report: Report
    @State private var isPressed: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                HStack(spacing: 16) {
                    if let uiImage = UIImage(data: report.imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(radius: 2, x: 0, y: 1)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(report.date.formatted(.iso8601.year().month().day()))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(report.result)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                        
                        Text("Tap for more info")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                    }
                }
                .padding(.horizontal)

            }
            .padding(.vertical)
            .frame(width: 300, height: 120)
            .background(Color(hex: "eeeeee"))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(radius: 3)
        }
    }
}


