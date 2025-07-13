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
    
    @State private var disabledEditButton: Bool = true
    
    @State private var name: String = ""
    @State private var purchase_desc: String = ""
    @State private var amount: String = ""
    
    @State private var spent: Bool = true
    @State private var received: Bool = false
    @State private var spent_or_received: Bool = false
    
    @State private var payment_method: String = ""
    
    @State private var paid: Bool = true
    @State private var payment_completed: Bool = true
    @State private var payment_pending: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // For the element's name
                TextField("\(purchase.name!)", text: $name, axis: .vertical)
                    .padding()
                    .font(.headline)
                    .foregroundStyle(Color.newFont)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                
                // For the purchase amount
                TextField("Purchase Amount" + purchase.amount!, text: $amount)
                    .padding()
                    .font(.subheadline)
                    .foregroundStyle(Color.newFont)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .keyboardType(.numberPad)
                
                    .onAppear {
                        amount = purchase.amount!
                    }
                
                // For the toggle for the spent or received
                HStack {
                    Button {
                        spent = true
                        received = false
                    } label: {
                       SText("Spent")
                            .padding(.vertical, 15)
                            .padding(.horizontal, 25)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.newFont)
                            .frame(maxWidth: .infinity)
                            .background(spent ? Color.red : Color.secondary)
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    Circle()
                        .foregroundStyle(Color.secondary)
                        .frame(height: 5)
                    
                    Spacer()
                    
                    Button {
                        spent = false
                        received = true
                    } label: {
                       SText("Received")
                            .padding(.vertical, 15)
                            .padding(.horizontal, 25)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.newFont)
                            .frame(maxWidth: .infinity)
                            .background(received ? Color.green : Color.secondary)
                            .clipShape(Capsule())
                    }
                }
                .padding(5)
                .background(.ultraThickMaterial)
                .clipShape(Capsule())
                
                // For the toggle that toggles between payment completed or pending
                HStack {
                    Button {
                        payment_completed = true
                        payment_pending = false
                    } label: {
                       SText("Completed")
                            .padding(.vertical, 15)
                            .padding(.horizontal, 25)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.newFont)
                            .frame(maxWidth: .infinity)
                            .background(payment_completed ? Color.green : Color.secondary)
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    Circle()
                        .foregroundStyle(Color.secondary)
                        .frame(height: 5)
                    
                    Spacer()
                    
                    Button {
                        payment_completed = false
                        payment_pending = true
                    } label: {
                       SText("Pending")
                            .padding(.vertical, 15)
                            .padding(.horizontal, 25)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.newFont)
                            .frame(maxWidth: .infinity)
                            .background(payment_pending ? Color.red : Color.secondary)
                            .clipShape(Capsule())
                    }
                }
                .padding(5)
                .background(.ultraThickMaterial)
                .clipShape(Capsule())
                
                // For the payment method field
                TextField("Payment Method", text: $payment_method, axis: .vertical)
                    .padding()
                    .font(.subheadline)
                    .foregroundStyle(Color.newFont)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                
                    .onAppear {
                        payment_method = purchase.payment_method!
                    }
                
                // For the purchase description
                TextField("\(purchase.purchase_desc!)", text: $purchase_desc, axis: .vertical)
                    .padding()
                    .font(.subheadline)
                    .foregroundStyle(Color.newFont)
                    .background(.ultraThickMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                
                    .onAppear {
                        name = purchase.name!
                        purchase_desc = purchase.purchase_desc!
                    }
            }
        }
        .onAppear {
            if purchase.spent_or_received {
                spent = false
                received = true
            } else {
                spent = true
                received = false
            }
            
            if purchase.paid {
                payment_completed = true
                payment_pending = false
            } else {
                payment_completed = false
                payment_pending = true
            }
        }
        
        .safeAreaInset(edge: .bottom) {
            Button {
                if name.trimmingCharacters(in: .whitespaces) == "" {
                    name = "New Purchase"
                }
                
                if spent {
                    spent_or_received = false
                } else {
                    spent_or_received = true
                }
                
                if payment_completed {
                    paid = true
                } else {
                    paid = false
                }
                
                DataController().editPurchase(purchase: purchase,
                                              name: name,
                                              purchase_desc: purchase_desc,
                                              amount: amount,
                                              payment_method: payment_method,
                                              paid: paid,
                                              spent_or_received: spent_or_received,
                                              context: managedObjectContext)
                dismiss()
            } label: {
                Label("Save changes", systemImage: "square.and.arrow.down.fill")
                    .padding()
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.newFont)
                    .background(Color.green)
                    .clipShape(Capsule())
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
        }
    }
}
