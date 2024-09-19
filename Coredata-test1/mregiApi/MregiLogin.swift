//
//  MregiLogin.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/05.
//

import SwiftUI

struct MregiLogin: View {
    @StateObject var model = LoginViewModel()

    var body: some View {
        ZStack{
            HStack{
                Button {
                    SwiftUI.Task {
                        await model.login()
                        //model.isProductSearchViewPresented = true
                    }
                } label: {
                    Text("ログイン").font(.system(size: 20, weight: .bold))
                        .frame(width: 158, height: 38)
                }
                Button {
                    SwiftUI.Task {
                        model.isProductSearchViewPresented = true
                    }
                } label: {
                    Text("商品リスト").font(.system(size: 20, weight: .bold))
                        .frame(width: 158, height: 38)
                }
                Button {
                    SwiftUI.Task {
                        model.isTransactionSearchViewPresented = true
                    }
                } label: {
                    Text("取引リスト").font(.system(size: 20, weight: .bold))
                        .frame(width: 158, height: 38)
                }
            }
        }
        .fullScreenCover(isPresented: $model.isProductSearchViewPresented) {
            ProductSearchView(
                selectedCategoryId: model.selectedCategoryId,
                onClose: { model.isProductSearchViewPresented = false },
                onCompletion: { product in
                    model.isProductSearchViewPresented = false
                }
            )
        }
        .fullScreenCover(isPresented: $model.isTransactionSearchViewPresented) {
            TransactionSearchView(
                selectedCategoryId: model.selectedCategoryId,
                onClose: { model.isTransactionSearchViewPresented = false },
                onCompletion: { transact in
                    model.isTransactionSearchViewPresented = false
                }
            )
        }
        .onAppear(perform: {
            model.loadValue()
        })
    }
}

class LoginViewModel: ObservableObject {
    private let useCase: LoginUseCaseProtocol
    init(useCase: LoginUseCaseProtocol = AppContainer.resolve(LoginUseCase.self)) {
        self.useCase = useCase
    }

    @Published var form = LoginForm(userId: "", password: "")
    @Published var isMainViewPresented = false
    @Published var errorMessage = ""

    @Published var isProductSearchViewPresented = false
    @Published var isTransactionSearchViewPresented = false
    @Published var selectedCategoryId: Int?

    @MainActor
    func login() async {
        let result = await useCase.login(form: form)

        if result?.error?.isEmpty == true, result?.user != nil, result?.auth != nil {
            isMainViewPresented = true
        } else {
            errorMessage = result?.message ?? "ログインエラー"
        }
    }

    @MainActor
    func loadValue() {
        form.userId = "testtest@test.test"
        form.password = "testtest"
    }
}

#Preview {
    MregiLogin()
}
