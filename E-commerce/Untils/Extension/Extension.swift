import SwiftUI
import UIKit
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    func formattedDate() -> String {
        let possibleFormats = [
            "yyyy-MM-dd",   // e.g. "2020-11-20"
            "dd MMMM yyyy", // e.g. "10 November 2025"
            "dd MMM yyyy",  // e.g. "10 Nov 2025"
            "EEEE, dd MMMM yyyy", // eg Friday, 31 October 2025
            "dd-MM-yyyy"
        ]
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy" // → "10 Nov 2025"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        for format in possibleFormats {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = format
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let dateObject = inputFormatter.date(from: self) {
                return outputFormatter.string(from: dateObject)
            }
        }
        
        // fallback if none match
        return self
    }
    
    func formattedTime() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: self) else {
            return self // fallback if parsing fails
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        return outputFormatter.string(from: date)
    }
    func formattedOnlyHourly() -> String {
        let components = self.lowercased().components(separatedBy: " ")

        if let hourIndex = components.firstIndex(where: { $0.contains("hour") }),
           components.indices.contains(hourIndex - 1) {
            let hours = components[hourIndex - 1]
            return "\(hours) hours"
        }

        return "0 hours" // fallback if parsing fails
    }



    func formattedDuration() -> String {
        // Extract numbers for hours and minutes
        let hourRegex = try! NSRegularExpression(pattern: "(\\d+)\\s*hour")
        let minuteRegex = try! NSRegularExpression(pattern: "(\\d+)\\s*minute")

        var hours = ""
        var minutes = ""

        if let match = hourRegex.firstMatch(in: self, range: NSRange(location: 0, length: self.count)),
           let range = Range(match.range(at: 1), in: self) {
            hours = String(self[range])
        }

        if let match = minuteRegex.firstMatch(in: self, range: NSRange(location: 0, length: self.count)),
           let range = Range(match.range(at: 1), in: self) {
            minutes = String(self[range])
        }

        if !hours.isEmpty && !minutes.isEmpty {
            return "\(hours)h \(minutes)mn"
        } else if !hours.isEmpty {
            return "\(hours)h"
        } else if !minutes.isEmpty {
            return "\(minutes)mn"
        } else {
            return self // fallback
        }
    }

    func toTimeDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }
    
    func toDateTimeP() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }


    func toRequestDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy" // matches backend format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }

    func toRequestDutyDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy" // matches backend format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }

    func formattedDutyDate() -> String {
        let possibleFormats = [
            "yyyy-MM-dd",   // e.g. "2020-11-20"
            "dd MMMM yyyy", // e.g. "10 November 2025"
            "dd MMM yyyy",  // e.g. "10 Nov 2025"
            "EEEE, dd MMMM yyyy", // eg Friday, 31 October 2025
            "dd-MM-yyyy"
        ]

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEEE, dd MMMM yyyy" // → "Friday, 31 October 2025"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")

        for format in possibleFormats {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = format
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")

            if let dateObject = inputFormatter.date(from: self) {
                return outputFormatter.string(from: dateObject)
            }
        }

        // fallback if none match
        return self
    }
    
    func toAMPM() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "hh:mm a"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: self) else {
            return self
        }
        
        return outputFormatter.string(from: date)
    }
    
    func toReadableTitle() -> String {
        return self
            .lowercased()                   // "go_outside"
            .replacingOccurrences(of: "_", with: " ") // "go outside"
            .capitalized                    // "Go Outside"
    }

}


extension View{
    func disableWithOpacity(_ condtion: Bool)-> some View{
        self
            .disabled(condtion)
            .opacity(condtion ? 0.6 : 1)
    }
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func tabSwipeGesture(
            selectedTab: Binding<String>,
            tabNames: [String],
            minimumDistance: CGFloat = 30,
            threshold: CGFloat = 50
    ) -> some View {
        self.gesture(
            DragGesture(minimumDistance: minimumDistance)
                .onEnded { value in
                    guard let currentIndex = tabNames.firstIndex(of: selectedTab.wrappedValue) else { return }
                    
                    let nextIndex: Int
                    if abs(value.translation.width) > threshold {
                        // Swipe left -> next tab
                        if value.translation.width < 0 {
                            nextIndex = min(currentIndex + 1, tabNames.count - 1)
                        }
                        // Swipe right -> previous tab
                        else {
                            nextIndex = max(currentIndex - 1, 0)
                        }
                        
                        if nextIndex != currentIndex {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab.wrappedValue = tabNames[nextIndex]
                            }
                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                            impactFeedback.impactOccurred()
                        }
                    }
                }
        )
    }
    
}
extension Binding where Value == String{
    func limit(_ length: Int)-> Self{
        if self.wrappedValue.count > length{
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        return self
    }
}

extension Date {
    
    func toRequestDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy" // your desired UI format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }

    func toRequestDateStringFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy" // your desired UI format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }
    
    func toRequestTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }

    func toYMD() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }

}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
