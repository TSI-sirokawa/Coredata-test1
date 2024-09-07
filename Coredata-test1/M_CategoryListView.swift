//
//  M_CategoryListView.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2022/11/08.
//

import SwiftUI

struct M_CategoryListView: View {
    /// 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    @StateObject private var m_categorymodel = M_CategoryModel()
    /// データ取得処理
    @FetchRequest(
        entity: M_CATEGORY.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \M_CATEGORY.updDateTime, ascending: true)],
        predicate: nil
    ) private var categories: FetchedResults<M_CATEGORY>
    
    @State private var searchText: String = ""
    
    @State private var selcntText: String = ""

    var body: some View {
        NavigationView {
            /// 取得したデータをリスト表示
            List {
                ForEach(categories) { category in
                    M_CategoryCardView(m_categoryModel: m_categorymodel, category: category)
//                    VStack {
//                        /// タスクの表示
//                        //(destination: UpdTaskView(rec: categories.first!)){
//                        NavigationLink(destination: AddTaskView()){
//                            //HStack {
//                            Image(systemName: category.checked ? "checkmark.circle.fill" : "circle")
//                                .onTapGesture {
//                                    category.checked.toggle()
//                                    try? context.save()
//                                }
//                            Text("\(category.categoryCode!)")
//                            Text("\(category.categoryName!)")
//                            Spacer()
//                            //}
//                        }
//
//                        //                    /// タスクをタップでcheckedフラグを変更する
//                        //                    .contentShape(Rectangle())
//                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("部門リスト" + selcntText)
            /// ツールバーの設定
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {

//                    NavigationLink(destination: AddTaskView()) {
//                        Image(systemName: "plus")
//                    }
                    Button(action:
                              {m_categorymodel.isNewData.toggle()
                              }){
                          Text("新規作成")
                    }
          //タップするとシートが開く
                      .sheet(isPresented: $m_categorymodel.isNewData,
                          content: {
                          M_CategorySheetView(m_categoryModel: m_categorymodel)
                      })
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())// iPhoneとiPadの見え方を同じにする
        .searchable(text: $searchText, prompt: "検索")
        // searchableの下に追加
        .onChange(of: searchText) { newValue in
            search(text: newValue)
        }
    }
    
    private func search(text: String) {
        if text.isEmpty {
            categories.nsPredicate = nil // ①
        } else {
            let titlePredicate: NSPredicate = NSPredicate(format: "categoryName contains %@", text) // ②
            //let contentPredicate: NSPredicate = NSPredicate(format: "content contains %@", text) // ③
            //tasks.nsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, contentPredicate]) //　④
            categories.nsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate]) //　④
        }
        
        selcntText = categories.count.description
        var sum : Int32 = 0
        for x in 0..<categories.count {
            var cat = categories[x]
            sum += cat.displaySequence
        }
        selcntText = sum.description
    }
    /// タスクの削除
    /// - Parameter offsets: 要素番号のコレクション
    func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            context.delete(categories[index])
        }
        try? context.save()
    }
}

struct M_CategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        M_CategoryListView()
    }
}
