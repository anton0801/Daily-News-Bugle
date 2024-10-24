import Foundation

func timeAgoSinceTimestamp(_ timestamp: Int) -> String {
    // Преобразуем timestamp в Date
    let postDate = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let now = Date()
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day, .hour], from: postDate, to: now)
    
    // Если прошло менее 24 часов
    if let hours = components.hour, hours < 24 {
        return "\(hours)h ago"
    }
    
    // Если прошло 1-2 дня
    if let days = components.day {
        switch days {
        case 1:
            return "1 day ago"
        case 2:
            return "2 days ago"
        case 3...5:
            return "\(days) days ago"
        default:
            // Если прошло более 5 дней, выводим дату
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: postDate)
        }
    }
    
    return ""
}

extension Double {
    func formatDouble(_ decimalPlaces: Int) -> String {
        return String(format: "%.\(decimalPlaces)f", self)
    }
}
