//
//  ExpenseDetailsView.swift
//  LearnSwiftUI
//
//  Created by Ladislav Szolik on 07.01.23.
//

import SwiftUI
import CoreData

struct ExpenseDetailsView: View {
  
  @Environment(\.managedObjectContext) private var viewContext
  
  @Binding var expenseDate: Date
  @Binding var expenseAmount: Double
  @Binding var expenseCategory: Category
  
  //TODO: optimize fetching categories
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true) ],
      animation: .default)
  private var categories: FetchedResults<Category>
  
  var body: some View {    
      Form {
          DatePicker("Date", selection: $expenseDate, displayedComponents: [.date])
          TextField("Amount", value: $expenseAmount, format: .number).keyboardType(.decimalPad)
          Picker("Category", selection: $expenseCategory) {
            ForEach(categories) { category in
              Text(category.name!).tag(category)
            }
          }        
      }.scrollDismissesKeyboard(.interactively)
        .navigationBarTitle("Expense",displayMode: .inline)    
  }
  
  private func saveExpense() {
    do {
        try viewContext.save()      
    } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}


struct ExpenseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
                  let viewContext = PersistenceController.shared.container.viewContext
      let cat = Category(context: viewContext)
      cat.id = UUID()
      cat.name = "Food"
      do {
          try viewContext.save()
      } catch {
          let nsError = error as NSError
          fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
      
      let expDate = Binding.constant(Date())
      let expAmount = Binding.constant(100.00)
      let expCategory = Binding.constant(cat)
      return ExpenseDetailsView(expenseDate:expDate, expenseAmount: expAmount, expenseCategory: expCategory ).environment(\.managedObjectContext, viewContext)
    }    
}


/*
 NavigationStack {
   Form {
     Section {
       DatePicker("Date", selection: Binding<Date>(get: {self.expense.timestamp ?? Date()}, set: {self.expense.timestamp = $0}), displayedComponents: [.date])
       
       TextField("Amount", value: $expense.amount, format: .number).keyboardType(.decimalPad)
       
       Picker("Category", selection: $expense.category) {
         ForEach(categories) { category in
           Text(category.name!).tag(Optional(category))
         }
       }
     }
   }.scrollDismissesKeyboard(.interactively)
   .navigationBarTitle("Expense",displayMode: .inline)
   .toolbar{
     ToolbarItem(placement: .navigationBarLeading) {
       Button("Cancel") {
         isShown = false
       }
     }
     ToolbarItem {
       Button("Save"){
         saveExpense()
         isShown = false
       }.disabled(expense.amount <= 0.0 )
     }
   }
 }
 */
