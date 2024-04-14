//
//  AllPurchasesView.swift
//  ThreeInOne
//
//  Created by Vedant Mistry on 17/12/23.
//

import SwiftUI
import CoreData 

struct AllPurchasesView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var purchases: FetchedResults<Purchase>

    @State private var searchText: String = ""
    
    var filteredPurchases: [Purchase] {
        guard !searchText.isEmpty else { return Array(purchases) }
        return purchases.filter {
            ($0.name?.localizedCaseInsensitiveContains(searchText) ?? false) ||
            ($0.purchase_desc?.localizedCaseInsensitiveContains(searchText) ?? false)
        }
    }

    @State private var showingAddPurchase: Bool = false
    @State private var showingEditPurchase: Bool = false
    @State private var selectedPurchase: Purchase?
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(alignment: .leading) {
                    List {
                        ForEach(filteredPurchases) { purchase in
                            NavigationLink(destination: EditPurchaseView(purchase: purchase)) {
                                VStack(alignment: .leading, spacing: 15) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(purchase.name!)
                                                .font(.headline)
                                            
                                            Spacer()
                                            
                                            Text(purchase.amount!)
                                                .font(.headline)
                                        }
                                    }
                                    
                                    HStack {
                                        Text(purchase.spent_or_received ? "Received" : "Spent")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 15)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.newFont)
                                            .frame(maxWidth: .infinity)
                                            .background(purchase.spent_or_received ? Color.green : Color.red)
                                            .clipShape(Capsule())
                                        
                                        Spacer()
                                        
                                        Text(purchase.paid ? "Completed" : "Pending")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 15)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.newFont)
                                            .frame(maxWidth: .infinity)
                                            .background(purchase.paid ? Color.green : Color.red)
                                            .clipShape(Capsule())
                                    }
                                    Text("Paid using: \(purchase.payment_method!.isEmpty ? "Not Specified " : purchase.payment_method!)")
                                        .font(.caption2)
                                        .foregroundStyle(.tertiary)
                                    
                                    VStack {
                                        if purchase.purchase_desc?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                                            Text(purchase.purchase_desc!)
                                                .lineLimit(1)
                                                .truncationMode(.tail)
                                                .padding(10)
                                                .font(.caption)
                                                .foregroundStyle(Color.newFont)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color.secondary)
                                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .listStyle(.inset)
                }
                .background(.ultraThinMaterial)
                .navigationTitle("Your Purchases")
                .navigationBarTitleDisplayMode(.large)
            }
            .searchable(text: $searchText)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack() {
                        Button(action: {
                            showingAddPurchase.toggle()
                        }) {
                            Image(systemName: "creditcard.fill")
                        }
                        .sheet(isPresented: $showingAddPurchase) {
                            AddPurchaseView()
                        }
                    }
                    .font(.title)
                    .bold()
                    .frame(width: 80, height: 80)
                    .background(.ultraThinMaterial)
                    .foregroundStyle(Color(UIColor(hex: "F8F7FF")))
                    .clipShape(Circle())
                    .shadow(radius: 30)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 120)
        }
    }
    
    private func deletePurchase(offsets: IndexSet) {
        withAnimation {
            offsets.map {
                purchases[$0]
            }.forEach(managedObjectContext.delete)
            
            DataController.shared.save(context: managedObjectContext)
        }
    }
}

#Preview {
    AllPurchasesView()
}
