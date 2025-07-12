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
    
    @State private var name: String = ""
    @State private var purchase_desc: String = ""
    @State private var amount: String = ""
    
    @State private var spent: Bool = true
    @State private var received: Bool = false
    @State private var spent_or_received: Bool = false
    
    @State private var payment_method: String = ""
    
    @State private var payment_completed: Bool = true
    @State private var payment_pending: Bool = false
    @State private var payment_status: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Purchase name
                    TextField("Name...", text: $name, axis: .vertical)
                        .padding()
                        .font(.subheadline)
                        .foregroundStyle(Color.newFont)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    
                    // Purchase description
                    TextField("Description...", text: $purchase_desc, axis: .vertical)
                        .padding()
                        .font(.subheadline)
                        .foregroundStyle(Color.newFont)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    
                    // Toggle for spent or received
                    HStack {
                        Button {
                            spent = true
                            received = false
                        } label: {
                            Text("Spent")
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
                            Text("Received")
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
                    
                    // Purchase amount
                    TextField("Amount..." + amount, text: $amount)
                        .padding()
                        .font(.subheadline)
                        .foregroundStyle(Color.newFont)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .keyboardType(.numberPad)
                    
                    // Toggle for completed or pending payment
                    HStack {
                        Button {
                            payment_completed = true
                            payment_pending = false
                        } label: {
                            Text("Completed")
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
                            Text("Pending")
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
                    
                    // type of payment method
                    TextField("Payment Method...", text: $payment_method, axis: .vertical)
                        .padding()
                        .font(.subheadline)
                        .foregroundStyle(Color.newFont)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                }
                .padding()
            }
            .navigationTitle("New Purchase")
            
            .safeAreaInset(edge: .bottom) {
                HStack {
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
                            payment_status = true
                        } else {
                            payment_status = false
                        }
                        
                        DataController.shared.addPurchase(name: name, purchase_desc: purchase_desc, amount: amount, payment_method: payment_method, paid: payment_status, spent_or_received: spent_or_received, context: managedObjectContext)
                        dismiss()
                    } label: {
                        Label("Add Purchase", systemImage: "plus")
                            .padding()
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.newFont)
                            .background(Color.green)
                            .clipShape(Capsule())
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .padding()
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
            }
        }
        .interactiveDismissDisabled()
    }
}
#Preview {
    AddPurchaseView()
}
