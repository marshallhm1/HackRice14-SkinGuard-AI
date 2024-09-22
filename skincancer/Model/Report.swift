import SwiftData
import SwiftUI

@Model
class Report {
    var imageData: Data
    var result: String
    var date: Date
    var journalEntry: String = ""

    init(imageData: Data, result: String, date: Date, journalEntry: String) {
        self.imageData = imageData
        self.result = result
        self.date = date
        self.journalEntry = journalEntry
    }
}
