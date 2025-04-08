protocol IProductUseCase {
    func fetchProducts(skip: Int, limit: Int) async throws -> [Product]
    func searchProducts(query: String) async throws -> [Product]
    func fetchProductDetail(id: Int) async throws -> ProductDetail
}

class ProductUseCase: IProductUseCase {
    private let repository: IProductRepository
    
    init(repository: IProductRepository) {
        self.repository = repository
    }
    
    func fetchProducts(skip: Int, limit: Int) async throws -> [Product] {
        return try await repository.fetchProducts(skip: skip, limit: limit)
    }
    
    func searchProducts(query: String) async throws -> [Product] {
        return try await repository.searchProducts(query: query)
    }
    
    func fetchProductDetail(id: Int) async throws -> ProductDetail {
        return try await repository.fetchProductDetail(id: id)
    }
} 