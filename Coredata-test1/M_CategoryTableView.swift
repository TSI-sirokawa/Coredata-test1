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
        sortDescriptors: [NSSortDescriptor(keyPath: \M_CATEGORY.categoryCode, ascending: true)],
        predicate: nil
    ) private var categories: FetchedResults<M_CATEGORY>
    
    var body: some View {
            VStack{
                Table(categories){
                    TableColumn("部門コード"){ category in
                        Text("\(category.categoryCode!)")
                    }
                    .width(80)
                    TableColumn("部門名"){ category in
                        Button(action: {
                            m_categorymodel.EditItem(item: category)
                        }) {
                            Text("\(category.categoryName!)")
                        }
                    }
                    .width(100)
                    TableColumn("部門略称", value: \.categoryAbbr!)
                        .width(100)
                    TableColumn("表示順/\n端末表示"){ category in
                        VStack{
                            Text(String(category.displaySequence))
                            Text(displayFlagValue(displayFlag: category.displayFlag ?? ""))
                        }
                    }
                    TableColumn("税区分/軽減税率"){ category in
                        VStack{
                            Text(taxDivisionValue(taxDivision: category.taxDivision ?? ""))
                            Text(reduceTaxIdValue(reduceTaxId: Int(category.reduceTaxId)))
                        }
                    }
                    TableColumn("登録日時/更新日時"){ category in
                        VStack{
                            Text(category.insDateTime ?? Date(), formatter: DateJPFormatter)
                            Text(category.updDateTime ?? Date(), formatter: DateJPFormatter)
                        }
                    }
                }
            }
            .sheet(isPresented: $m_categorymodel.isNewData,
                   content: {
                M_CategorySheetView(m_categoryModel: m_categorymodel)
            })
    }
}
//日付表示のフォーマット
private let DateJPFormatter: DateFormatter = {
    let formatter = DateFormatter()
    //formatter.calendar = Calendar(identifier: .gregorian)
    //formatter.locale = Locale(identifier: "en_US")
    formatter.locale = Locale(identifier: "ja_JP")
    //formatter.dateStyle = .medium
    //formatter.timeStyle = .none
    formatter.dateFormat = "YYYY/MM/dd(E) HH:mm:ss"
    return formatter
}()
//端末表示区分
private func displayFlagValue(displayFlag: String) -> String{
    var value = ""
    
    if (displayFlag == "0"){
        value = "表示しない"
    }else{
        value = "表示する"
    }
    return value
}
//税区分
private func taxDivisionValue(taxDivision: String) -> String{
    var value = ""
    switch taxDivision {
    case "0":
        value = "内税"
    case "1":
        value = "外税"
    case "2":
        value = "非課税"
    default:
        value = ""
    }
    return value
}

//軽減税率
private func reduceTaxIdValue(reduceTaxId: Int) -> String{
    var value = ""
    switch reduceTaxId {
    case 10000001:
        value = "軽減"
    case 10000002:
        value = "選択［標準］"
    case 10000003:
        value = "選択［軽減］"
    case 10000004:
        value = "選択［選択］"
    default:
        value = "該当なし"
    }
    return value
}

struct M_CategoryTableView_Previews: PreviewProvider {
    static var previews: some View {
        M_CategoryTableView()
    }
}
