//
//  CategoryDetailsView.swift
//  LearnSwiftUI
//
//  Created by Ladislav Szolik on 07.01.23.
//

import SwiftUI

struct CategoryDetailsView: View {
  @Binding var isShown:Bool
  @Environment(\.managedObjectContext) private var viewContext
  
  @State private var newCategoryName = String()
    var body: some View {
      NavigationStack {
        Form {
          TextField("Name", text: $newCategoryName).autocorrectionDisabled(true)
        }.toolbar{
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
              isShown = false
            }
          }
          ToolbarItem {
            Button("Done"){
              saveCategory()
              isShown = false
            }.disabled(newCategoryName.isEmpty)
          }
        }
      }
    }
  
  private func saveCategory() {
    let newCategory = Category(context: viewContext)
    newCategory.id = UUID()
    newCategory.name = newCategoryName
    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
  }
}

struct CategoryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
      CategoryDetailsView(isShown: Binding.constant(true)).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
