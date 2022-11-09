//
//  M_CategoryCardView.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2022/10/31.
//

import SwiftUI

struct M_CategoryCardView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var m_categoryModel : M_CategoryModel
    @ObservedObject var category : M_CATEGORY
    
    var body: some View {
        HStack{
            //CoreDataに保存されたデータを表示
            VStack {
                Text(category.categoryCode ?? "")
                Text(category.categoryName ?? "")
                Text(category.insDateTime ?? Date(), formatter: itemFormatter)
            }
            .onTapGesture {
                m_categoryModel.EditItem(item: category)
            }
            //Image(systemName: samples.bool ? "star.fill":"star")
        }
        //カードの形
        .frame(
            minWidth:UIScreen.main.bounds.size.width * 0.9,
            maxWidth: UIScreen.main.bounds.size.width * 0.9,
            minHeight:UIScreen.main.bounds.size.height * 0.2,
            maxHeight: UIScreen.main.bounds.size.height * 0.8
        )
        .background(RoundedRectangle(cornerRadius: 15)
            .fill(Color(.systemGray5)))
        //カード長押しで編集と削除のボタンを表示
        .contextMenu(menuItems: {
            Button(action: {
                m_categoryModel.EditItem(item: category) //内部でm_categoryModel.isNewDataがtrueに設定され、ContentViewの新規作成ボタンのシートがアクティブになる
            })
            {
                Text("編集")
                Image(systemName: "pencil")
                    .foregroundColor(Color.blue)
            }
//            .sheet(isPresented: $m_categoryModel.isNewData,
//                content: {
//                M_CategorySheetView(m_categoryModel: m_categoryModel)
//            })
            Button(action: {
                context.delete(category)
                try! context.save()
                
            })
            {
                Text("削除")
                Image(systemName: "trash")
                    .foregroundColor(Color.blue)
            }
            
        })
    }
}
//日付表示のフォーマット
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    //formatter.calendar = Calendar(identifier: .gregorian)
    //formatter.locale = Locale(identifier: "en_US")
    formatter.locale = Locale(identifier: "ja_JP")
    //formatter.dateStyle = .medium
    //formatter.timeStyle = .none
    formatter.dateFormat = "YYYY/MM/dd(E) HH:mm:ss"
    return formatter
}()
//日付の文字列からDate型へ変換関数
//使用例
//var dataFromAPI:String
//start_date: StringToDate(dateValue: dataFromAPI, format: "yyyy/MM/dd")
func StringToDate(dateValue: String, format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateValue) ?? Date()
}
