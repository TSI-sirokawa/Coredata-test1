//
//  M_CategorySheetView.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2022/10/31.
//

import SwiftUI

struct M_CategorySheetView: View {
    @ObservedObject var m_categoryModel : M_CategoryModel
    @Environment(\.managedObjectContext)private var context
    
    var body: some View {
        VStack(alignment: .leading){
            //キャンセルボタンと保存ボタン
            HStack {
                //キャンセルの場合は保存せず閉じる
                Button("Cansel", action:{
                    //m_categoryModel.isNewData = false
                    m_categoryModel.CanselData()
                }).foregroundColor(.blue)
                Spacer()
                //保存の場合はモデルでデータ処理
                Button("Save", action:
                        {
                    m_categoryModel.WriteData(context: context)
                }
                ).foregroundColor(.blue)
            }
            .padding(.bottom, 20.0)
            Group{
                //日付の選択
                //            DatePicker("", selection: $sampleModel.date, displayedComponents: .date)
                //                .labelsHidden()
                //文字の入力
                HStack{
                    Text("部門コード")
                    TextField("部門コード", text: $m_categoryModel.categorycode).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack{
                    Text("部門名")
                    TextField("部門名", text: $m_categoryModel.categoryname).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack{
                    Text("部門名略称")
                    TextField("部門名略称", text: $m_categoryModel.categoryAbbr).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack{
                    Text("表示順")
                    TextField("表示順", value: $m_categoryModel.displaySequence, formatter: NumberFormatter()).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack{
                    Text("端末表示")
                    Picker(selection: $m_categoryModel.displayFlag, label: Text("端末表示")){
                        Text("表示しない").tag("0")
                        Text("表示する").tag("1")
                    }
                }
                HStack{
                    Text("税区分")
                    Picker(selection: $m_categoryModel.taxDivision, label: Text("税区分")){
                        Text("内税").tag("0")
                        Text("外税").tag("1")
                        Text("非課税").tag("2")
                    }
                }
                HStack{
                    Text("軽減税率ID")
                    TextField("軽減税率ID", text: $m_categoryModel.reduceTaxId).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
            }
            Group{
                HStack{
                    Text("端末表示カラー")
                    TextField("端末表示カラー", text: $m_categoryModel.color).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack{
                    Text("部門グループID")
                    TextField("部門グループID", value: $m_categoryModel.categoryGroupId, formatter: NumberFormatter()).textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack{
                    Text("親部門ID")
                    TextField("親部門ID", value: $m_categoryModel.parentCategoryId, formatter: NumberFormatter()).textFieldStyle(RoundedBorderTextFieldStyle())
                }
//                //Bool値の選択ボタン
//                Button(action: {m_categoryModel.bool.toggle()}){
//                    Image(systemName: m_categoryModel.bool ? "star.fill":"star")
//                }
                Spacer()
            }
        }.padding()
    }
}

//プレビュー用コード
struct M_CategorySheetView_Previews: PreviewProvider {
    static var previews: some View {
        M_CategorySheetView(m_categoryModel: M_CategoryModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
