//
//  AddItemView.swift
//  LearnSwiftUI
//
//  Created by Ladislav Szolik on 06.01.23.
//

import SwiftUI

struct NewExpenseView: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  
  @Binding var isShown: Bool
  
  @State private var amount: Double? = nil
  @State private var dateSelection = Date()
  @State private var selectedCategory: Category? = nil
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true) ],
      animation: .default)
  private var categories: FetchedResults<Category>
  
    var body: some View {
      NavigationStack {
        Form {        
          Section {
            DatePicker("Date", selection: $dateSelection, displayedComponents: [.date])
            
            TextField("Amount", value: $amount, format: .number).keyboardType(.decimalPad)
                        
            if !categories.isEmpty {
              Picker("Category", selection: $selectedCategory) {
                ForEach(categories) { category in
                  Text(category.name!).tag(Optional(category))
                }
              }.onAppear{
                if self.selectedCategory == nil {
                  self.selectedCategory = self.categories.first
                }
              }
            } else {
              Label("Missing categories", systemImage: "info.circle").foregroundColor(.red)
            }
          }
        }.scrollDismissesKeyboard(.interactively)
          .navigationBarTitle("New", displayMode: .inline)
          .toolbar{
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
              isShown = false
            }
          }
          
          ToolbarItem {
            Button("Save") {
              saveExpense()
              isShown = false
            }.disabled(amount == nil || selectedCategory == nil)
          }
        }
      }
    }
  
  
  private func saveExpense() {
    let newExpense = Expense(context: viewContext)
    newExpense.timestamp = dateSelection
    guard let enteredAmount = amount else {
      return
    }
    newExpense.amount = enteredAmount
    newExpense.category = selectedCategory
    
    guard let selCat =  selectedCategory else {
      return
    }
    selCat.addToExpenses(newExpense)
    do {
        try viewContext.save()
      
    } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}



struct NewExpenseView_Previews: PreviewProvider {
    static var previews: some View {
      NewExpenseView(isShown: Binding.constant(true)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
