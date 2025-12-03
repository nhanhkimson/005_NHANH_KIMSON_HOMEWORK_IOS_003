//
//  Functionality.swift
//  E-commerce
//
//  Created by Apple on 8/25/25.
//

import SwiftUI


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Fomat the currency
func formatCurrency(_ amount: Double, currencyCode: String = "USD") -> String{
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencyCode = currencyCode
    return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
}
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

struct PrimaryButton_: View {
    var text: String = ""
    var buttonType: Int
    var action: ()-> Void = {}
    var size: String = "lg"
    var body: some View {
        Button(action: action,
        label: {
            Text(text)
                .foregroundStyle(buttonType == 1 ? .blue : buttonType == 3 ? Color.black : .white)
                .frame(maxWidth: .infinity)
                .font(.title3)
                .padding(.vertical, buttonType == 1 ? 0 : size == "sm" ? 9 : 14)
                .background((buttonType == 1 || buttonType == 3) ? .clear : Color(.blue))
                .overlay(
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(Color.blue, lineWidth: buttonType == 3 ? 2 : 0)
                )
                .clipShape(RoundedRectangle(cornerRadius: .infinity))

        })
    }
}





func primaryButtonIcon(text: String, iconName: String, action:@escaping() -> Void) -> some View{
    Button(action: action, label: {
        HStack{
            bedge(iconName: iconName)
                .frame(width: 42)
            Text(text)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .lineLimit(1)
            Spacer()
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 36)
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.leading)
        .background(
            RoundedRectangle(cornerRadius: .infinity)
                .stroke(.gray.opacity(0.2))
        )
    })
}

func bedge(iconName: String) -> some View{
    Image(iconName)
        .resizable()
        .scaledToFit()
}
#Preview {
    ContentView()
}
func getLanguageName(identifier: String)-> String{
    switch identifier{
    case "en": return "English"
    case "km": return "Khmer"
    case "ko": return "Korean"
    default: return "English"
    }
}
