//
//  M_CategoryModel.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2022/10/31.
//

import Foundation
import SwiftUI
import CoreData

class M_CategoryModel : ObservableObject{
    @Published var categoryid : Int32 = 0
    @Published var categorycode = ""
    @Published var categoryname = ""
    @Published var categoryAbbr = ""
    @Published var displaySequence : Int32 = 0
    @Published var displayFlag = "1"
    @Published var taxDivision = "0"
    //@Published var reduceTaxId : Int32 = 0
    @Published var reduceTaxId = "" //: Int32 = 0
    @Published var color = ""
    @Published var categoryGroupId : Int32 = 0
    @Published var parentCategoryId : Int32 = 0
    @Published var level = "1"
    @Published var insDateTime = Date()
    @Published var updDateTime = Date()
    
    @Published var bool = false
    
    @Published var isNewData = false
    @Published var updateItem : M_CATEGORY!
    
    func CanselData(){
        isNewData.toggle()        
        //変数クリア
        ClearVariable()
        
        return
    }
    
    func WriteData(context: NSManagedObjectContext){
        if updateItem != nil{
            updateItem.categoryCode = categorycode
            updateItem.categoryName = categoryname
            updateItem.categoryAbbr = categoryAbbr
            updateItem.displaySequence = displaySequence
            updateItem.displayFlag = displayFlag
            updateItem.taxDivision = taxDivision
            updateItem.reduceTaxId = reduceTaxId
            updateItem.color = color
            updateItem.categoryGroupId = categoryGroupId
            updateItem.parentCategoryId = parentCategoryId
            updateItem.level = level
            updateItem.updDateTime = Date()
            
            do{
                try context.save()
            }catch{
                print(error)
            }
            
            //フラグクリア
            updateItem = nil
            isNewData.toggle()
            
            //変数クリア
            ClearVariable()
            
            return
        }
        let newItem = M_CATEGORY(context: context)
        newItem.categoryId = 0 //採番
        newItem.categoryCode = categorycode
        newItem.categoryName = categoryname
        newItem.categoryAbbr = categoryAbbr
        newItem.displaySequence = displaySequence
        newItem.displayFlag = displayFlag
        newItem.taxDivision = taxDivision
        newItem.reduceTaxId = reduceTaxId
        newItem.color = color
        newItem.categoryGroupId = categoryGroupId
        newItem.parentCategoryId = parentCategoryId
        newItem.level = level
        newItem.insDateTime = Date()
        newItem.updDateTime = Date()

        do{
            try context.save()
            //フラグクリア
            isNewData.toggle()
            
            //変数クリア
            ClearVariable()
//            categoryid = 0
//            categorycode = ""
//            categoryname = ""
        }catch{
            print(error)
        }
    }
    //編集の時は既存データを利用する
    func EditItem(item: M_CATEGORY){
        updateItem = item
        
        categoryid = item.categoryId
        categorycode = item.categoryCode ?? ""
        categoryname = item.categoryName ?? ""
        categoryAbbr = item.categoryAbbr ?? ""
        displaySequence = item.displaySequence
        displayFlag = item.displayFlag ?? ""
        taxDivision = item.taxDivision ?? ""
        reduceTaxId = item.reduceTaxId ?? ""
        color = item.color ?? ""
        categoryGroupId = item.categoryGroupId
        parentCategoryId = item.parentCategoryId
        level = item.level ?? "1"
        insDateTime = item.insDateTime ?? Date()
        updDateTime = item.updDateTime ?? Date()

        isNewData = true //ContentViewの新規ボタンのsheetがアクティブになる false
    }
    
    func ClearVariable(){
        updateItem = nil
        categoryid = 0
        categorycode = ""
        categoryname = ""
        categoryAbbr = ""
        displaySequence = 0
        displayFlag = "1"
        taxDivision = "0"
        reduceTaxId = "" //0
        color = ""
        categoryGroupId = 0
        parentCategoryId = 0
        level = "1"
        insDateTime = Date()
        updDateTime = Date()

    }
}
