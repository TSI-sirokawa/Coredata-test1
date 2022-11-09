//
//  M_CategoryTableView.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2022/11/09.
//

import SwiftUI

struct M_CategoryTableView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject private var m_categorymodel = M_CategoryModel()
    /// データ取得処理
    @FetchRequest(
        entity: M_CATEGORY.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \M_CATEGORY.updDateTime, ascending: true)],
        predicate: nil
    ) private var categories: FetchedResults<M_CATEGORY>

    var body: some View {
        VStack{
            Table(categories){
                TableColumn("部門コード"){ category in
                    Text("\(category.categoryCode!)")
                }
                TableColumn("部門名"){ category in
                    Button(action: {
                        m_categorymodel.EditItem(item: category)
                        print("bumon")
                    }) {
                        Text("\(category.categoryName!)")
                    }                }
                //TableColumn("部門名", value: \.categoryName!)
                TableColumn("部門略称", value: \.categoryAbbr!)
            }
        }
        .sheet(isPresented: $m_categorymodel.isNewData,
            content: {
            M_CategorySheetView(m_categoryModel: m_categorymodel)
        })
    }
}

struct M_CategoryTableView_Previews: PreviewProvider {
    static var previews: some View {
        M_CategoryTableView()
    }
}
