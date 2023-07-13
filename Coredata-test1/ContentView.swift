//
//  ContentView.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2022/10/19.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var tabSelection = 0
    
    var body: some View {
        TabView(selection: $tabSelection){
            M_CategoryListView()
                .tabItem {
                    Image(systemName: "square.and.arrow.up")
                    Text("部門1")
                }.tag(0)

            M_CategoryLinkView()
                .tabItem {
                    Image(systemName: "list.clipboard.fill")
                    Text("部門ナビ")
                }.tag(1)

            M_CategoryTableView()
                .tabItem {
                    Image(systemName: "pencil.circle")
                    Text("部門テーブル")
                }.tag(2)

        }
    }
    
}

struct TabBView: View {
    var body: some View {
        Text("TabB")
    }
}
/// タスク追加View
struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var categorycode = ""
    @State private var categoryname = ""
    
    var body: some View {
        Form {
            Section() {
                TextField("部門コードを入力", text: $categorycode)
                TextField("部門名を入力", text: $categoryname)
            }
        }
        .navigationTitle("部門追加")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    /// 部門新規登録処理
                    let newCategory = M_CATEGORY(context: context)
                    newCategory.categoryCode = categorycode
                    newCategory.categoryName = categoryname
                    newCategory.insDateTime = Date()
                    newCategory.updDateTime = Date()
                    newCategory.checked = false
                    
                    try? context.save()
                    
                    /// 現在のViewを閉じる
                    presentationMode.wrappedValue.dismiss()
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
