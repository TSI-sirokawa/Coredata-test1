//
//  ProductSearchView.swift
//  mReji
//
//  Created by 鈴木仁 on 2024/05/14.
//

import SwiftUI

struct ProductSearchView: View {
    let selectedCategoryId: Int?
    let onClose: () -> Void
    let onCompletion: (ProductInfo) -> Void
    @StateObject var model = ProductSearchViewModel()

    var body: some View {
        VStack {
            headerView()
            productList()
                .padding(.top, 30)
            Spacer()
        }
        .cornerRadius(10)
        .frame(width: 550, height: 630)
    }

    private func headerView() -> some View {
        VStack {
            HStack {
                Text("商品検索")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 15)
                Spacer()
                Button {
                    onClose()
                } label: {
                    Text("")
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

    private func productList() -> some View {
        ScrollView {
            LazyVStack(spacing: 0.0) {
                ForEach(Array(model.productList.enumerated()), id: \.offset) { index, product in
                    ProductCell(
                        product: product,
                        index: index,
                        action: { productInfo in
                            onCompletion(productInfo)
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

    private struct ProductCell: View {
        var product: ProductInfo
        var index: Int
        var action: (ProductInfo) -> Void
        var body: some View {
            Button {
                action(product)
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 0.0) {
                        HStack {
                            Text("部門: \(product.categoryName)")
                                .font(.system(size: 15))
                                .foregroundColor(ColorThemeManager.Constant.textSecondary)
                            Text("商品番号: \(product.productNumber)")
                                .font(.system(size: 15))
                                .foregroundColor(ColorThemeManager.Constant.textSecondary).padding(.leading, 15)
                        }
                        Text(product.productName)
                            .font(.system(size: 20))
                            .foregroundColor(ColorThemeManager.shared.primary)
                            .lineLimit(1)
                            .padding(.top, 5)
                    }
                    Spacer()
                    VStack(spacing: 0.0) {
                        Text("単価")
                            .foregroundColor(ColorThemeManager.Constant.textSecondary)
                            .font(.system(size: 15))
                        Text("¥\(product.price)")
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

class ProductSearchViewModel: ObservableObject {
    let perPageCount = 100
    @Published var keyword = ""
    @Published var isLoading = false
    @Published var isRefreshing = false
    @Published var canLoadMore = false
    @Published var productList: [ProductInfo] = []

    private let useCase: ProductListUseCaseProtocol
    init(useCase: ProductListUseCaseProtocol = AppContainer.resolve(ProductListUseCase.self)) {
        self.useCase = useCase
    }

    @MainActor
    func fetch(categoryId: Int?) async {
        self.isLoading = true
        let result = await useCase.fetch(form: ProductListForm(currentPage: 1, perPage: perPageCount, categoryId: categoryId, keyword: keyword))
        self.canLoadMore = result?.data?.paginate.totalCount ?? 0 > perPageCount
        productList = result?.data?.lists ?? []
        self.isLoading = false
    }

    @MainActor
    func fetchMore(categoryId: Int?) async {
        guard !isLoading, productList.count.isMultiple(of: perPageCount) else {
            canLoadMore = false
            return
        }
        self.isLoading = true
        let nextPage = productList.count / perPageCount + 1
        let result = await useCase.fetch(form: ProductListForm(currentPage: nextPage, perPage: perPageCount, categoryId: categoryId, keyword: keyword))
        productList.append(contentsOf: result?.data?.lists ?? [])
        self.canLoadMore = productList.count != result?.data?.paginate.totalCount
        self.isLoading = false
    }

    @MainActor
    func refresh(categoryId: Int?) async {
        self.isRefreshing = true
        productList = []
        await fetch(categoryId: categoryId)
        self.isRefreshing = false
    }
}

#Preview {
    ProductSearchView(selectedCategoryId: nil, onClose: {}, onCompletion: { _ in })
}
