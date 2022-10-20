//
//  ContentView.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2022/10/19.
//

import SwiftUI
import CoreData

struct ContentView: View {
    /// 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    /// データ取得処理
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.timestamp, ascending: true)],
        predicate: nil
    ) private var tasks: FetchedResults<Task>


    var body: some View {
        NavigationView {
            /// 取得したデータをリスト表示
            List {
                ForEach(tasks) { task in
                    
                    /// タスクの表示
                    HStack {
                        Image(systemName: task.checked ? "checkmark.circle.fill" : "circle")
                        Text("\(task.name!)")
                        Spacer()
                    }
                    
                    /// タスクをタップでcheckedフラグを変更する
                    .contentShape(Rectangle())
                    .onTapGesture {
                        task.checked.toggle()
                        try? context.save()
                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("Todoリスト")
            /// ツールバーの設定
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTaskView()) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    /// タスクの削除
    /// - Parameter offsets: 要素番号のコレクション
    func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            context.delete(tasks[index])
        }
        try? context.save()
    }

}
/// タスク追加View
struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var task = ""
    
    var body: some View {
        Form {
            Section() {
                TextField("タスクを入力", text: $task)
            }
        }
        .navigationTitle("タスク追加")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    /// タスク新規登録処理
                    let newTask = Task(context: context)
                    newTask.timestamp = Date()
                    newTask.checked = false
                    newTask.name = task
                    
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
