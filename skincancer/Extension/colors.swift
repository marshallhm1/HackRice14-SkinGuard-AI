import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        
        let r = Double((hexNumber & 0xff0000) >> 16) / 255
        let g = Double((hexNumber & 0x00ff00) >> 8) / 255
        let b = Double(hexNumber & 0x0000ff) / 255
        
        self.init(red: r, green: g, blue: b)
    }

    static let charcoal = Color(hex: "2e5266")
    static let slateGray = Color(hex: "6e8898")
    static let cadetGray = Color(hex: "9fb1bc")
    static let timberwolf = Color(hex: "d3d0cb")
    static let oldGold = Color(hex: "e2c044")
}
