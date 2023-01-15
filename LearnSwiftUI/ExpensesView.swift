//
//  ExpensesView.swift
//  LearnSwiftUI
//
//  Created by Ladislav Szolik on 14.01.23.
//

import SwiftUI



struct ExpensesView: View {

  @Environment(\.managedObjectContext) private var viewContext
  
  @SectionedFetchRequest<Date, Expense>(
    sectionIdentifier: \.monthAndYear,
      sortDescriptors: [NSSortDescriptor(keyPath: \Expense.timestamp, ascending: false) ]
  )
  private var expensesByMonth: SectionedFetchResults<Date, Expense>
  
  @State private var isNewExpenseShown = false
  
    var body: some View {
      NavigationView {
        VStack {
          List {
            ForEach(expensesByMonth) { month in
              Section(header: SectionSegmentView(month: month.id, sum: month.reduce(0.0) {$0 + $1.amount})) {
                ForEach(month) { expense in
                  NavigationLink {
                    ExpenseDetailsView(expenseDate: Binding<Date>(get: {expense.timestamp ?? Date()}, set: {expense.timestamp = $0}),
                                       expenseAmount: Binding<Double>(get: {expense.amount}, set: {expense.amount = $0}),
                                       expenseCategory: Binding<Category>(get:{expense.category!}, set:{expense.category = $0})
                    )
                  } label: {
                    ExpenseRowView(expense: expense)
                  }
                }
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
        }.navigationBarTitleDisplayMode(.inline)
      }
    }
}

// MARK: Delete expense
extension ExpensesView {
  private func deleteItems(at offsets: IndexSet, in section: SectionedFetchResults<Date, Expense>.Section) {
    
    //TODO: find a better way to get index
    
    let segmentIndex = expensesByMonth.firstIndex { sec in
      sec.id == section.id
    }
    
      withAnimation {
          offsets.map { expensesByMonth[segmentIndex!][$0] }.forEach(viewContext.delete)
          do {
              try viewContext.save()
          } catch {
              let nsError = error as NSError
              print("Error in DeleteItem: \(nsError), \(nsError.userInfo)")
          }
      }
  }
}

private let expenseDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.setLocalizedDateFormatFromTemplate("MMM yy")
    return formatter
}()



struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


/*
 List {
   ForEach(expensesByMonth) { singleMonth in
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
   
 }.sheet(isPresented: $isExpDetailShown, onDismiss: { isExpDetailShown = false}) {
   ExpenseDetailsView(isShown: $isExpDetailShown, expense: $selectedExpense )
 }
 */
