//
//  M_CategoryLinkView.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2022/11/09.
//

import SwiftUI

struct M_CategoryLinkView: View {
    /// 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    @StateObject private var m_categorymodel = M_CategoryModel()
    
    @State private var searchText: String = ""
    /// データ取得処理
    @FetchRequest(
        entity: M_CATEGORY.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \M_CATEGORY.updDateTime, ascending: true)],
        predicate: nil
    ) private var categories: FetchedResults<M_CATEGORY>
    
    @State var isEditActive = false
    
    var body: some View {
        NavigationView {
            ZStack{
                //更新画面への遷移の為の隠しNavigationLink
                NavigationLink(destination: UpdTaskView(m_categoryModel: m_categorymodel), isActive: $isEditActive, label: { EmptyView()})
                NavigationLink(destination: AddTaskView(), isActive: $m_categorymodel.isNewData, label: { EmptyView()})
                /// 取得したデータをリスト表示
                
                List {
                    ForEach(categories) { category in
                        HStack {
                            /// タスクの表示
                            //HStack {
                            Image(systemName: category.checked ? "checkmark.circle.fill" : "circle")
                                .onTapGesture {
                                    category.checked.toggle()
                                    try? context.save()
                                }
                            Text("\(category.categoryCode!)")
                            Button(action: {
                                m_categorymodel.EditItem(item: category)
                                // 通信を行う模擬実装
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    isEditActive = true
                                }
                            }) {
                                Text("\(category.categoryName!)")
                            }
                            Text("\(category.categoryAbbr!)")
                            
                            Spacer()
                        }
                    }
                    .onDelete(perform: deleteTasks)
                }
                .navigationTitle("部門リスト")
                /// ツールバーの設定
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action:
                                {m_categorymodel.isNewData.toggle()
                        }){
                            Text("新規作成")
                        }
                        //                        //タップするとシートが開く
                        //                        .sheet(isPresented: $m_categorymodel.isNewData,
                        //                               content: {
                        //                            M_CategorySheetView(m_categoryModel: m_categorymodel)
                        //                        })
                    }
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
    }
    func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            context.delete(categories[index])
        }
        try? context.save()
    }
}

/// 部門更新View
struct UpdTaskView: View {
    @ObservedObject var m_categoryModel : M_CategoryModel
    @Environment(\.managedObjectContext)private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var categorycode: String = ""
    @State private var categoryname = ""
    
    //    init(rec: M_CATEGORY){
    //        self._categorycode = ""//rec.categoryCode ? ""
    //        self._categorycode = "1"//rec.categoryCode ?? ""
    //    }
    var body: some View {
        Form {
            Section() {
                TextField("部門コードを入力", text: $m_categoryModel.categorycode)
                TextField("部門名を入力", text: $m_categoryModel.categoryname)
                //Text("部門名略称")
                TextField("部門名略称", text: $m_categoryModel.categoryAbbr)
                TextField("表示順", value: $m_categoryModel.displaySequence, formatter: NumberFormatter())
                Picker(selection: $m_categoryModel.displayFlag, label: Text("端末表示")){
                    Text("表示しない").tag("0")
                    Text("表示する").tag("1")
                }
            }
        }
        .navigationTitle("部門更新")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    m_categoryModel.WriteData(context: context)
                    /// 現在のViewを閉じる
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct M_CategoryLinkView_Previews: PreviewProvider {
    static var previews: some View {
        M_CategoryLinkView()
    }
}
