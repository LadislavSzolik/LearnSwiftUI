//
//  ExpenseDetailsView.swift
//  LearnSwiftUI
//
//  Created by Ladislav Szolik on 07.01.23.
//

import SwiftUI

struct ExpenseDetailsView: View {
  @Environment(\.managedObjectContext) private var viewContext
  
  @ObservedObject var expense: Expense
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true) ],
      animation: .default)
  private var categories: FetchedResults<Category>
 
  var body: some View {
    NavigationStack {
      Form {
        DatePicker("Date", selection: Binding<Date>(get: {self.expense.timestamp ?? Date()}, set: {self.expense.timestamp = $0}), displayedComponents: [.date])
        TextField("Amount", value: $expense.amount, format: .number).keyboardType(.decimalPad)
        Picker("Category", selection: $expense.category) {
          ForEach(categories) { category in
            Text(category.name!).tag(Optional(category))
          }
        }
      }.navigationBarTitle("Expense",displayMode: .inline).toolbar{
        ToolbarItem {
          Button("Done"){
            saveExpense()
          }.disabled(expense.category == nil)
        }
      }
    }
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

/*
struct ExpenseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      ExpenseDetailsView(expense: Expense()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}*/
