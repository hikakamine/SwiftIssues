import Foundation

extension Date {

    func formatted(withFormat format: String = "yyyy/MM/dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
