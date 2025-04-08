protocol IProductRepository {
    func fetchProducts(skip: Int, limit: Int) async throws -> [Product]
    func searchProducts(query: String) async throws -> [Product]
    func fetchProductDetail(id: Int) async throws -> ProductDetail
}

struct ProductPage {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
} 