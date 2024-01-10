//
//  AddPurchaseView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import SwiftUI
import CoreData

struct AddPurchaseView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var customTabViewModel = CustomTabViewModel()
    
    @State private var name: String = ""
    @State private var purchase_desc: String = ""
    @State private var amount: String = ""
    @State private var spent_or_received: Bool = false
    @State private var payment_method: String = ""
    @State private var paid: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Purchase Name", text: $name, axis: .vertical)
                            .foregroundStyle(Color.newFont)
                            .font(.headline)
                            .bold()
                        
                        TextField("Purchase Description", text: $purchase_desc, axis: .vertical)
                            .foregroundStyle(Color.newFont)
                            .font(.subheadline)
                    }
                    
                    Section {
                        TextField("Purchase Amount" + amount, text: $amount)
                            .foregroundStyle(Color.newFont)
                            .font(.subheadline)
                            .keyboardType(.numberPad)
                        
                        
                        Toggle("Spent or Received?", isOn: $spent_or_received)
                            .foregroundStyle(Color.newFont)
                            .font(.headline)
                    }
                    
                    Section {
                        Toggle("Completed Payment?", isOn: $paid)
                            .foregroundStyle(Color.newFont)
                            .font(.headline)
                        
                        TextField("Payment Method", text: $payment_method, axis: .vertical)
                            .foregroundStyle(Color.newFont)
                            .font(.subheadline)
                    }
                }
                Group {
                    Button {
                        if name.trimmingCharacters(in: .whitespaces) == "" {
                            name = "New Purchase"
                        }
                        if purchase_desc.trimmingCharacters(in: .whitespaces) == "" {
                            purchase_desc = "Purchase Description"
                        }
                        DataController.shared.addPurchase(name: name, purchase_desc: purchase_desc, amount: amount, payment_method: payment_method, paid: paid, spent_or_received: spent_or_received, context: managedObjectContext)
                        dismiss()
                    } label: {
                        Label("Add Purchase", systemImage: "plus")
                    }
                    .padding()
                    .bold()
                    .font(.title3)
                    .background(Color(UIColor(hex: customTabViewModel.tabBarItems[0].accentColor)))
                    .foregroundStyle(Color.newFont)
                    .clipShape(RoundedRectangle(cornerRadius: 1000.0))
                }
            }
            .navigationTitle("New Purchase")
        }
    }
}
#Preview {
    AddPurchaseView()
}
