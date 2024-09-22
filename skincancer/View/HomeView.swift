import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Report.date, order: .reverse) var reports: [Report]
    @Query var weeklyCheckIns: [WeeklyCheckIn]
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header Section
                    VStack(spacing: 15){
                        HStack{
                            Text("Welcome back :)")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.charcoal)
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 8) {
                            Text("You're on a symptom logging roll!")
                                .font(.system(size: 32, weight: .bold))
                                .fontWeight(.bold)
                                .foregroundColor(.charcoal)
                        }

                        Text("You logged \(weeklyCheckIns.filter { $0.checkedIn }.count) weeks this month")
                            .font(.subheadline)
                            .foregroundColor(.slateGray)
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)

                    // Weekly Check-in Overview
                    VStack(alignment: .leading) {
                        Text("Weekly Check-ins")
                            .font(.headline)
                            .foregroundColor(.charcoal)
                            .padding(.leading)

                        HStack(spacing: 20) {
                            ForEach(0..<4) { week in
                                let checkIn = weeklyCheckIns.first { $0.week == week }
                                Circle()
                                    .fill(checkIn?.checkedIn == true ? Color.oldGold : Color.cadetGray)
                                    .frame(width: 60, height: 60)
                                    .overlay(Text("W\(week+1)").foregroundColor(.white).bold())
                                    .shadow(radius: 5)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 10)
                    .background(Color.timberwolf)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                    // Quick Actions Section (Two Square Tiles)
                    HStack(spacing: 20) {
                        NavigationLink(destination: CameraView()) {
                            ActionTile(label: "Submit a New Report", icon: "camera.fill", backgroundColor: .charcoal)
                        }
                        NavigationLink(destination: DoctorSearchView()) {
                            ActionTile(label: "Find a Doctor Nearby", icon: "stethoscope.circle.fill", backgroundColor: .oldGold)
                        }
                    }
                    .padding(.horizontal)

                    // Checklist Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Checklist")
                            .font(.headline)
                            .padding(.leading)
                            .foregroundColor(.charcoal)

                        ChecklistView()
                    }
                    .padding(.vertical, 10)
                    .background(Color.timberwolf)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
            .onAppear {
                updateWeeklyCheckIns()
            }
        }
    }

    private func updateWeeklyCheckIns() {
        let calendar = Calendar.current
        let currentDate = Date()
        
        for week in 0..<4 {
            let weekStart = calendar.date(byAdding: .day, value: -week * 7, to: currentDate)!
            let weekEnd = calendar.date(byAdding: .day, value: -6, to: weekStart)!
            
            let reportsThisWeek = reports.filter { report in
                return report.date >= weekEnd && report.date <= weekStart
            }
            
            let checkedIn = !reportsThisWeek.isEmpty
            
            if let existingCheckIn = weeklyCheckIns.first(where: { $0.week == week }) {
                existingCheckIn.checkedIn = checkedIn
            } else {
                let newCheckIn = WeeklyCheckIn(week: week, checkedIn: checkedIn)
                modelContext.insert(newCheckIn)
            }
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save weekly check-ins: \(error)")
        }
    }
}

struct ActionTile: View {
    let label: String
    let icon: String
    let backgroundColor: Color

    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.bottom, 10)

            Text(label)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
