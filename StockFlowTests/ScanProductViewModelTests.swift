//
//  ScanProductViewModelTests.swift
//  StockFlow
//
//  Created by Cicek on 15.10.26.
//

import Testing
@testable import StockFlow

@MainActor
struct ScanProductViewModelTests {

    private func makeSUT() -> (
        viewModel: ScanProductViewModel,
        productRepository: MockProductRepository,
        salesRepository: MockSalesRepository
    ) {
        let productRepository = MockProductRepository()
        let salesRepository = MockSalesRepository()
        let viewModel = ScanProductViewModel(
            productRepository: productRepository,
            salesStore: SalesStore(salesRepository: salesRepository),
            productsStore: ProductsStore(productRepository: productRepository)
        )
        return (viewModel, productRepository, salesRepository)
    }

    @Test func scanningKnownSkuShowsProduct() async {
        let sut = makeSUT()
        sut.productRepository.singleProductResult = .success(TestData.product(id: 7))

        await sut.viewModel.handleScanned(code: "  SKU-1 \n")

        guard case .found(let product) = sut.viewModel.state else {
            Issue.record("Expected .found state")
            return
        }
        #expect(product.id == 7)
        #expect(sut.productRepository.requestedSkus == ["SKU-1"])
        #expect(sut.viewModel.quantity == 1)
    }

    @Test func scanningUnknownSkuShowsNotFound() async {
        let sut = makeSUT()
        sut.productRepository.singleProductResult =
            .failure(NetworkError.serverError(statusCode: 404, message: "Product not found"))

        await sut.viewModel.handleScanned(code: "UNKNOWN")

        guard case .notFound(let code) = sut.viewModel.state else {
            Issue.record("Expected .notFound state")
            return
        }
        #expect(code == "UNKNOWN")
    }

    @Test func scanFailureShowsError() async {
        let sut = makeSUT()
        sut.productRepository.singleProductResult = .failure(TestError.failed)

        await sut.viewModel.handleScanned(code: "SKU-1")

        guard case .error(let message) = sut.viewModel.state else {
            Issue.record("Expected .error state")
            return
        }
        #expect(message == "Test failure")
    }

    @Test func completeSaleSucceeds() async {
        let sut = makeSUT()
        sut.productRepository.singleProductResult =
            .success(TestData.product(id: 7, price: 10, quantity: 5))
        sut.salesRepository.createSaleResult = .success(TestData.createSaleResponse(total: 30))
        await sut.viewModel.handleScanned(code: "SKU-1")
        sut.viewModel.increment()
        sut.viewModel.increment()

        await sut.viewModel.completeSale()

        guard case .saleCompleted(let total) = sut.viewModel.state else {
            Issue.record("Expected .saleCompleted state")
            return
        }
        #expect(total == 30)
        #expect(sut.salesRepository.createSaleRequests.count == 1)
        #expect(sut.salesRepository.createSaleRequests.first?.productId == 7)
        #expect(sut.salesRepository.createSaleRequests.first?.quantity == 3)
    }

    @Test func completeSaleFailureKeepsProductAndShowsError() async {
        let sut = makeSUT()
        sut.productRepository.singleProductResult = .success(TestData.product(quantity: 5))
        sut.salesRepository.createSaleResult = .failure(TestError.failed)
        await sut.viewModel.handleScanned(code: "SKU-1")

        await sut.viewModel.completeSale()

        guard case .found = sut.viewModel.state else {
            Issue.record("Expected .found state to remain")
            return
        }
        #expect(sut.viewModel.submitError == "Test failure")
        #expect(sut.viewModel.isSubmitting == false)
    }

    @Test func quantityStaysBetweenOneAndStock() async {
        let sut = makeSUT()
        sut.productRepository.singleProductResult = .success(TestData.product(quantity: 2))
        await sut.viewModel.handleScanned(code: "SKU-1")

        for _ in 0..<5 { sut.viewModel.increment() }
        #expect(sut.viewModel.quantity == 2)

        for _ in 0..<5 { sut.viewModel.decrement() }
        #expect(sut.viewModel.quantity == 1)
    }
}
