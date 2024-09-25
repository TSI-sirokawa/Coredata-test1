//
//  TransactionSearchView.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/18.
//

import SwiftUI

struct TransactionSearchView: View {
    let selectedCategoryId: Int?
    let onClose: () -> Void
    let onCompletion: (TransactionInfo) -> Void
    @StateObject var model = TransactionSearchViewModel()

    var body: some View {
        VStack {
            headerView()
            transactionList()
                .padding(.top, 30)
            Spacer()
        }
        .cornerRadius(10)
        .frame(width: 850, height: 630)
    }

    private func headerView() -> some View {
        VStack {
            HStack {
                Text("取引検索")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 15)
                Spacer()
                Button {
                    onClose()
                } label: {
                    Text("終了")
                }
            }
            .padding(.horizontal, 20)

            HStack {
                SearchView(keyword: $model.keyword, onSearch: { SwiftUI.Task { await model.refresh(categoryId: selectedCategoryId) } })
                Spacer()
            }
            .padding(.top, 5)
            .padding(.leading, 20)
        }
    }

    private func transactionList() -> some View {
        ScrollView {
            LazyVStack(spacing: 0.0) {
                ForEach(Array(model.transactionList.enumerated()), id: \.offset) { index, transaction in
                    TransactionCell(
                        transaction: transaction,
                        index: index,
                        action: { transactionInfo in
                            onCompletion(transactionInfo)
                        }
                    )
                }
                if (model.canLoadMore || model.isLoading) && !model.isRefreshing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: ColorThemeManager.shared.primary))
                        .onAppear {
                            SwiftUI.Task {
                                await model.fetchMore(categoryId: selectedCategoryId)
                            }
                        }
                }
            }
            .task {
                await model.fetch(categoryId: selectedCategoryId)
            }
        }
        .refreshable {
            await model.refresh(categoryId: selectedCategoryId)
        }
    }

    private struct TransactionCell: View {
        var transaction: TransactionInfo
        var index: Int
        var action: (TransactionInfo) -> Void
        var body: some View {
            Button {
                action(transaction)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 0.0) {
                        HStack {
                            Text("店舗: \(transaction.storeName)")
                                .font(.system(size: 15))
                                .foregroundColor(ColorThemeManager.Constant.textSecondary)
                            Text("番号: \(transaction.transactionId)")
                                .font(.system(size: 15))
                                .foregroundColor(ColorThemeManager.Constant.textSecondary).padding(.leading, 15)
                        }
                        Text("¥\(transaction.storeId)")
                            .font(.system(size: 20))
                            .foregroundColor(ColorThemeManager.shared.primary)
                            .lineLimit(1)
                            .padding(.top, 5)
                    }
                    Spacer()
                    VStack(spacing: 0.0) {
                        Text("合計金額")
                            .foregroundColor(ColorThemeManager.Constant.textSecondary)
                            .font(.system(size: 15))
                        Text("¥\(transaction.transactionId)")
                            .font(.system(size: 20))
                            .foregroundColor(ColorThemeManager.shared.primary)
                    }
                }
                .padding(.vertical, 5)
                .background(index.isMultiple(of: 2) ? ColorThemeManager.Constant.bgMain : ColorThemeManager.shared.bgMenu)
                .padding(.horizontal, 20)
            }
        }
    }
}


class TransactionSearchViewModel: ObservableObject {
    let perPageCount = 50 //100
    @Published var keyword = ""
    @Published var isLoading = false
    @Published var isRefreshing = false
    @Published var canLoadMore = false
    @Published var transactionList: [TransactionInfo] = []

    private let useCase: TransactionListUseCaseProtocol
    init(useCase: TransactionListUseCaseProtocol = AppContainer.resolve(TransactionListUseCase.self)) {
        self.useCase = useCase
    }

    @MainActor
    func fetch(categoryId: Int?) async {
        self.isLoading = true
        let result = await useCase.fetch(form: TransactionListForm(currentPage: 1, perPage: perPageCount))
        self.canLoadMore = result?.data?.paginate.totalCount ?? 0 > perPageCount
        transactionList = result?.data?.lists ?? []
        self.isLoading = false
    }

    @MainActor
    func fetchMore(categoryId: Int?) async {
        guard !isLoading, transactionList.count.isMultiple(of: perPageCount) else {
            canLoadMore = false
            return
        }
        self.isLoading = true
        let nextPage = transactionList.count / perPageCount + 1
        let result = await useCase.fetch(form: TransactionListForm(currentPage: nextPage, perPage: perPageCount))
        transactionList.append(contentsOf: result?.data?.lists ?? [])
        self.canLoadMore = transactionList.count != result?.data?.paginate.totalCount
        self.isLoading = false
    }

    @MainActor
    func refresh(categoryId: Int?) async {
        self.isRefreshing = true
        transactionList = []
        await fetch(categoryId: categoryId)
        self.isRefreshing = false
    }
}


#Preview {
    TransactionSearchView(selectedCategoryId: nil, onClose: {}, onCompletion: { _ in })
}
