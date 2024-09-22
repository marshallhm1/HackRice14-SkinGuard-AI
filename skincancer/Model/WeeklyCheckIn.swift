import SwiftData
import SwiftUI
@Model
class WeeklyCheckIn {
    var week: Int
    var checkedIn: Bool

    init(week: Int, checkedIn: Bool) {
        self.week = week
        self.checkedIn = checkedIn
    }
}
