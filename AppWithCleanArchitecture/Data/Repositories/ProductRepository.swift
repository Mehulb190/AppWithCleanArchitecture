class ProductRepository: IProductRepository {
    private let apiService: IAPIService
    
    init(apiService: IAPIService = APIService()) {
        self.apiService = apiService
    }
    
    func fetchProducts(skip: Int, limit: Int) async throws -> [Product] {
        let response: ProductResponseDTO = try await apiService.get(endpoint: "/products?skip=\(skip)&limit=\(limit)")
        return response.products.map { $0.toDomain() }
    }
    
    func searchProducts(query: String) async throws -> [Product] {
        let response: ProductResponseDTO = try await apiService.get(endpoint: "/products/search?q=\(query)")
        return response.products.map { $0.toDomain() }
    }
    
    func fetchProductDetail(id: Int) async throws -> ProductDetail {
        let productDTO: ProductDetailDTO = try await apiService.get(endpoint: "/products/\(id)")
        return productDTO.toDomain()
    }
} 