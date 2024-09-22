import SwiftUI
import CarouselStack

struct TipsView: View {
    @State private var tipsShown: [Tip] = []
    let support = supportGroups
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Greeting Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Hi!")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.charcoal)
                        
                        Text("You’re not alone")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.charcoal)
                    }
                    .padding(.horizontal)
                    
                    // Information Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Nearly 20% of melanoma patients experience significant itching or tenderness around the affected area during treatment.")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.slateGray)
                        
                        HStack {
                            Text("Itching")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.charcoal)
                            
                            Spacer()
                            
                            Text("Tenderness")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.charcoal)
                        }
                        
                        ProgressView(value: 0.20)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.oldGold))
                            .frame(height: 8)
                            .background(Color.cadetGray.opacity(0.3))
                            .cornerRadius(4)
                    }
                    .padding()
                    .background(Color.timberwolf)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Tips Section Header
                    Text("A few tips to help you feel better")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.charcoal)
                        .padding(.horizontal)
                    
                    // Tips List
                    VStack(spacing: 30){
                        VStack(spacing: 10) {
                            ForEach(tipsShown) { tip in
                                TipRow(icon: tip.icon, text: tip.text, expandedText: tip.expandedText)
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 15){
                            Text("Support Groups Near You")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.charcoal)
                                .padding(.horizontal)
                                
                            CarouselStack(support, initialIndex: 0) { s in
                           ZStack{
                                        Color.timberwolf
                                            .frame(height: 150)
                                            .cornerRadius(16)
                                        VStack{
                                            Text(s.description)
                                                .font(.system(size: 10, weight: .medium))
                                                .foregroundColor(.charcoal)
                                                .padding(.horizontal)
                                            
                                            VStack(spacing: 10){
                                                Text(s.name)
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundColor(.charcoal)
                                                
                                                Text("Go to site")
                                                    .font(.system(size: 12, weight: .light))
                                                    .foregroundColor(.slateGray)
                                            }.padding(.top, 5)
                                        }
                                    }
                           .onTapGesture {
                               if let url = URL(string: s.website) {
                                   UIApplication.shared.open(url)
                               }
                           }
                                }
                        
                            
                        }
                    }
                    
                    // Show More Tips Button
                    Button(action: {
                        showRandomTips()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 18, weight: .medium))
                            
                            Text("Show more tips")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.charcoal)
                        .background(Color.timberwolf)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
            .onAppear {
                showRandomTips()
            }
        }
    }
    
    private func showRandomTips() {
        tipsShown.removeAll()
        var availableTips = tips.shuffled()
        for _ in availableTips[0..<3] {
            if let tip = availableTips.popLast() {
                tipsShown.append(tip)
            }
        }
    }
}

struct TipRow: View {
    let icon: String
    let text: String
    let expandedText: String
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.charcoal)
                    .padding(.trailing, 10)
                
                Text(text)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.charcoal)
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.charcoal)
            }
            .padding()
            .background(Color.timberwolf)
            .cornerRadius(10)
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                Text(expandedText)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.slateGray)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .transition(.opacity)
            }
        }
        .background(Color.timberwolf)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
            .previewDevice("iPhone 14 Pro")
    }
}
