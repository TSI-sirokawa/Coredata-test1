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
    enum FocusFields{
        case categorycode
        case categoryname
        case categoryAbbr
        case displaySequence
        case displayFlag
        case taxDivision
        case reduceTaxId
        case color
        case categoryGroupId
        case parentCategoryId
    }
    @FocusState var focuseState : FocusFields?
    
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
                    TextField("部門コード", text: $m_categoryModel.categorycode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focused($focuseState, equals: .categorycode)
                        .onSubmit({focuseState = .categoryname})
                }
                HStack{
                    Text("部門名")
                    TextField("部門名", text: $m_categoryModel.categoryname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.namePhonePad)
                        .focused($focuseState, equals: FocusFields.categoryname)
                        .onSubmit({focuseState = .categoryAbbr})
                }
                HStack{
                    Text("部門名略称")
                    TextField("部門名略称", text: $m_categoryModel.categoryAbbr)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.namePhonePad)
                        .focused($focuseState, equals: FocusFields.categoryAbbr)
                        .onSubmit{focuseState = .displaySequence}
                }
                HStack{
                    Text("表示順")
                    TextField("表示順", value: $m_categoryModel.displaySequence, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focused($focuseState, equals: FocusFields.displaySequence)
                        .onSubmit({focuseState = .displayFlag})
                }
                HStack{
                    Text("端末表示")
                    Picker(selection: $m_categoryModel.displayFlag, label: Text("端末表示")){
                        Text("表示しない").tag("0")
                        Text("表示する").tag("1")
                    }
                    .focused($focuseState, equals: FocusFields.displayFlag)
                }
                HStack{
                    Text("税区分")
                    Picker(selection: $m_categoryModel.taxDivision, label: Text("税区分")){
                        Text("内税").tag("0")
                        Text("外税").tag("1")
                        Text("非課税").tag("2")
                    }
                    .focused($focuseState, equals: FocusFields.taxDivision)
                }
                HStack{
                    Text("軽減税率ID")
                    //TextField("軽減税率ID", text: $m_categoryModel.reduceTaxId)
                    TextField("軽減税率ID", value: $m_categoryModel.reduceTaxId, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .focused($focuseState, equals: FocusFields.reduceTaxId)
                        .onSubmit({focuseState = .color})
                }
                
            }
            Group{
                HStack{
                    Text("端末表示カラー")
                    TextField("端末表示カラー", text: $m_categoryModel.color)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focuseState, equals: FocusFields.color)
                        .onSubmit({focuseState = .categoryGroupId})
                }
                HStack{
                    Text("部門グループID")
                    TextField("部門グループID", value: $m_categoryModel.categoryGroupId, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focuseState, equals: FocusFields.categoryGroupId)
                        .onSubmit({focuseState = .parentCategoryId})
                }
                HStack{
                    Text("親部門ID")
                    TextField("親部門ID", value: $m_categoryModel.parentCategoryId, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($focuseState, equals: FocusFields.parentCategoryId)
                }
                Spacer()
            }
        }
        .onAppear {
            /// 0.5秒の遅延発生後TextFieldに初期フォーカスをあてる
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                focuseState = .categorycode
            }
        }
        .onChange(of: m_categoryModel.displayFlag){ newValue in
            focuseState = .taxDivision
        }
        .onChange(of: m_categoryModel.taxDivision){ newValue in
            focuseState = .reduceTaxId
        }
        
        //.padding()
    }
}

//プレビュー用コード
struct M_CategorySheetView_Previews: PreviewProvider {
    static var previews: some View {
        M_CategorySheetView(m_categoryModel: M_CategoryModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
