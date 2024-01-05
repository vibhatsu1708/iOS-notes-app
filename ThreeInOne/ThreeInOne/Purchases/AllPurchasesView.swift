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
    
    @Binding var isCustomTabBarHidden: Bool

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
                            NavigationLink(destination: EditPurchaseView(purchase: purchase, isCustomTabBarHidden: $isCustomTabBarHidden)) {
                                VStack(alignment: .leading, spacing: 12) {
                                    VStack(alignment: .leading) {
                                        Text(purchase.name!)
                                            .font(.headline)
                                        Text(purchase.purchase_desc!)
                                            .font(.subheadline)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("Amount: \(purchase.amount!)")
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(purchase.spent_or_received ? "Received" : "Spent")
                                                .bold()
                                                .font(.headline)
                                            Spacer()
                                            Text(purchase.paid ? "Paid" : "Not Paid")
                                                .padding(.vertical, 5)
                                                .padding(.horizontal, 10)
                                                .background(purchase.paid ? LinearGradient(colors: [Color(UIColor(hex: "FFE66D"))], startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(colors: [Color(UIColor(hex: "FE5F55"))], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .foregroundStyle(Color.black)
                                                .bold()
                                                .clipShape(RoundedRectangle(cornerRadius: 1000.0))
                                        }
                                        Text("Paid by: \(purchase.payment_method!.isEmpty ? "Not Specified " : purchase.payment_method!)")
                                            .font(.caption2)
                                            .foregroundStyle(.tertiary)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deletePurchase)
                        .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity)
                }
                .navigationTitle("Your Purchases")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
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
                    .background(LinearGradient(colors: [Color(UIColor(hex: "D5D887")), Color(UIColor(hex: "A1CF6B")), Color(UIColor(hex: "7AC74F"))], startPoint: .topLeading, endPoint: .bottomTrailing))
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
    AllPurchasesView(isCustomTabBarHidden: .constant(true))
}
