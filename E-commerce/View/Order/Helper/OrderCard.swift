//
//  Untitled.swift
//  Psakhmer
//
//  Created by Apple on 9/1/25.
//
import SwiftUI

struct OrderCard: View {
    var text: String = "OnProcess"
    var image: String = ""
    var qauntity: Int = 20
    var color: Color = .clear
    var price: Double = 100.00
    var staticColor: String = "white"
    var body: some View {
        HStack{
            VStack(spacing: 16){
                HStack{
                    HStack{
                        bedge(iconName: image)
                            .cornerRadius(12)
                            .frame(width: 96)
                        VStack(alignment: .leading){
                            Text("Bix Bag Limited Edittion 2029")
                                .bold()
                            Group{
                                Text("Color: \(staticColor)")
                                Text("Qty: \(qauntity)")
                            }
                            .foregroundStyle(Color.gray)
                            .font(.footnote)
                        }
                    }
                    VStack{
                        MiniButton(text: text, varain: color)
                    }
                }
                HStack{
                    PrimaryButton(title: "Detail"){}
                    PrimaryButton(title: "Tracking"){}
                }
            }
        }
        .padding()
        .overlay{
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.12), lineWidth: 2)
        }
    }
}

#Preview{
    Order()
}
