//
//  ContentView.swift
//  LearnSwiftUI
//
//  Created by Ladislav Szolik on 05.01.23.
//

import SwiftUI
import CoreData
import Charts

extension Expense {
  @objc
  var monthAndYear: Date {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month], from: self.timestamp!)
    components.day = 1
    return calendar.date(from: components) ?? Date()
  }
}

struct ContentView: View {
  
  enum Page: String, CaseIterable, Identifiable {
      case expenses, summary
      var id: Self { self }
  }
  
  @State private var currentView:Page = .expenses
  
  var body: some View {
        NavigationStack {
          VStack {
            if currentView == .expenses {
              ExpensesView()
            } else {
              SummaryView()
            }
          }.navigationBarTitleDisplayMode(.inline).toolbar{
            ToolbarItem(placement: .principal) {
              HStack {
                Picker("Page", selection: $currentView) {
                  ForEach(Page.allCases) { page in
                    Text(page.rawValue.capitalized).tag(page)
                  }
                }.pickerStyle(.segmented)
              }
            }
          }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



/* 
 ForEach(suma.expenses) { exp in
   HStack {
     Text(exp.month)
     Spacer()
     Text(exp.amount)
   }
 }
 
 Button(action: toggleDetails ) {
   HStack {
     Text(expense.timestamp!, formatter: expenseDateFormatter ).foregroundColor(.gray)
     Spacer()
     VStack(alignment:.trailing) {
       HStack{
         Text("CHF")
         Text(expense.amount.formatted())
       }
       Text(expense.category?.name ?? "").foregroundColor(.gray).font(.subheadline)
     }
   }}.sheet(isPresented: $isExpDetailShown) {
     ExpenseDetailsView(expense: expense, isShown: $isExpDetailShown)
   }
 
 
 NavigationLink {
   ExpenseDetailsView(expense: expense, isShown: $isExpDetailShown)
 } label: {
   HStack {
     Text(expense.timestamp!, formatter: expenseDateFormatter ).foregroundColor(.gray)
     Spacer()
     VStack(alignment:.trailing) {
       HStack{
         Text("CHF")
         Text(expense.amount.formatted())
       }
       Text(expense.category?.name ?? "").foregroundColor(.gray).font(.subheadline)
     }
   }
 }
 
 var sum: Double {
   expenses.reduce(0.0) {$0 + $1.amount}
 }
 

 
 
 struct ExpensesItem:Identifiable {
   let id = UUID()
   let amount: Double
   let month: String
 }
 
 struct Summary: Identifiable {
   let id = UUID()
   let cat: String
   let expenses:[ ExpensesItem]
 }
 
 let summary :[Summary] = [
   .init(cat: "Food", expenses: [.init(amount: 320.0, month: "Jan"), .init(amount: 430.4, month: "Feb"), .init(amount: 230.3, month: "Mar")]),
  
 ]
 ForEach(summary) { suma in
   Section(header: Text(suma.cat)) {
     Chart(suma.expenses, id: \.month) { exp in
         BarMark(
           x: .value("Category", exp.month),
           y: .value("Value", exp.amount)
         )
     }
   }.padding(.vertical)
 }
 
 .sheet(isPresented: $isExpDetailShown, onDismiss: { isExpDetailShown = false}) {
   ExpenseDetailsView( expense: selectedExpense )
 }
 
 List {
   ForEach(expensesSegmented) { singleMonth in
     Section(singleMonth.id) {
       ForEach(singleMonth) { expense in
         HStack {
           Text(expense.timestamp!, formatter: expenseDateFormatter ).foregroundColor(.gray)
           Spacer()
           VStack(alignment:.trailing) {
             HStack{
               Text("CHF")
               Text(expense.amount.formatted())
             }
             Text(expense.category?.name ?? "").foregroundColor(.gray).font(.subheadline)
           }
           Button("") {
             selectedExpense = expense
             isExpDetailShown = true
           }
         }
       }.onDelete{deleteItems(at: $0, in: singleMonth)}
     }
   }
 }
 
 
 HStack {
   Button("Add expense") {
     isNewExpenseShown.toggle()
   }.sheet(isPresented: $isNewExpenseShown) {
     NewExpenseView( isShown: $isNewExpenseShown)
   }.bold()
   Spacer()
   NavigationLink ("Categories") {
     CategoryDetailsView()
   }.bold()
   
 }.padding()
 
 
 
 
 
 */
