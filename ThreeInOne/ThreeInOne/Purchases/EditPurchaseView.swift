//
//  EditPurchaseView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import SwiftUI

struct EditPurchaseView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    var purchase: FetchedResults<Purchase>.Element
    
//    @Binding var isAddButtonHidden: Bool
    
    @State private var disabledEditButton: Bool = true
    
    @State private var name: String = ""
    @State private var purchase_desc: String = ""
    @State private var amount: String = ""
    @State private var spent_or_received: Bool = false
    @State private var payment_method: String = ""
    @State private var paid: Bool = true
    
    var body: some View {
        Form {
            Section {
                TextField("\(purchase.name!)", text: $name, axis: .vertical)
                    .bold()
                    .font(.headline)
                TextField("\(purchase.purchase_desc!)", text: $purchase_desc, axis: .vertical)
                    .font(.subheadline)
                
                    .onAppear {
                        name = purchase.name!
                        purchase_desc = purchase.purchase_desc!
                    }
                    .onChange(of: name) { _, _ in
                        updateButtonState()
                    }
                    .onChange(of: purchase_desc) { _, _ in
                        updateButtonState()
                    }
            }
            
            Section {
                TextField("Purchase Amount" + purchase.amount!, text: $amount)
                    .keyboardType(.numberPad)
                    .font(.headline)
                
                    .onAppear {
                        amount = purchase.amount!
                    }
                    .onChange(of: amount) {
                        updateButtonState()
                    }
            }
            
            Section {
                Toggle("Spent or Received?", isOn: $spent_or_received)
                    .foregroundStyle(Color.newFont)
                    .font(.headline)
                Toggle("Completed Payment?", isOn: $paid)
                    .foregroundStyle(Color.newFont)
                    .font(.headline)
                
                    .onAppear {
                        spent_or_received = purchase.spent_or_received
                        paid = purchase.paid
                    }
                    .onChange(of: spent_or_received) {
                        updateButtonState()
                    }
                    .onChange(of: paid) {
                        updateButtonState()
                    }
            }
            
            Section {
                TextField("Payment Method", text: $payment_method, axis: .vertical)
                    .foregroundStyle(Color.newFont)
                    .font(.subheadline)
                
                    .onAppear {
                        payment_method = purchase.payment_method!
                    }
                    .onChange(of: payment_method) {
                        updateButtonState()
                    }
            }
        }
        Button {
            if name.trimmingCharacters(in: .whitespaces) == "" {
                name = "New Purchase"
            }
            if purchase_desc.trimmingCharacters(in: .whitespaces) == "" {
                purchase_desc = "Purchase Description"
            }
            
            DataController().editPurchase(purchase: purchase, name: name, purchase_desc: purchase_desc, amount: amount, payment_method: payment_method, paid: paid, spent_or_received: spent_or_received, context: managedObjectContext)
            dismiss()
        } label: {
            Label("Add Changes", systemImage: "plus")
        }.disabled(disabledEditButton)
        .padding()
        .bold()
        .font(.title3)
        .background(!disabledEditButton ? Color.green : Color.secondary)
        .foregroundStyle(Color.newFont)
        .clipShape(RoundedRectangle(cornerRadius: 1000.0))
        .onAppear {
//            isCustomTabBarHidden = true
//            isAddButtonHidden = true
        }
        .onDisappear {
//            isCustomTabBarHidden = false
//            isAddButtonHidden = false
        }
    }
    
    func updateButtonState() {
        disabledEditButton = (name == purchase.name) && (purchase_desc == purchase.purchase_desc) && (amount == purchase.amount) && (spent_or_received == purchase.spent_or_received) && (paid == purchase.paid) && (payment_method == purchase.payment_method)
    }
}
