//
//  ContentView.swift
//  LearnSwiftUI
//
//  Created by Ladislav Szolik on 05.01.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
      sortDescriptors: [NSSortDescriptor(keyPath: \Expense.timestamp, ascending: false) ],
        animation: .default)
    private var expenses: FetchedResults<Expense>
  
  
  @State private var isShowingSheet = false
  @State private var isAddCategoryShown = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                    NavigationLink {
                      ExpenseDetailsView(expense: expense)
                    } label: {
                      HStack {
                          Text(expense.timestamp!, style: .date).foregroundColor(.gray)
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
                }
                .onDelete(perform: deleteItems)
            }.navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }               
            }
          HStack {
            Button("Add expense") {
              isShowingSheet = true
            }.sheet(isPresented: $isShowingSheet) {
              NewExpenseView( isShown: $isShowingSheet)
            }.bold()
            Spacer()
            Button("New category") {
              isAddCategoryShown = true
            }.sheet(isPresented: $isAddCategoryShown) {
              CategoryDetailsView(isShown: $isAddCategoryShown)
            }
          }.padding()
          
        }
      
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { expenses[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
