import Combine

@MainActor
class ProductDetailViewModel: ObservableObject {
    @Published var productDetail: ProductDetail?
    @Published var isLoading = false
    @Published var error: String?
    
    private let productUseCase: IProductUseCase
    
    init(productUseCase: IProductUseCase = ProductUseCase(repository: ProductRepository())) {
        self.productUseCase = productUseCase
    }
    
    func fetchProductDetail(id: Int) async {
        isLoading = true
        error = nil
        
        do {
            productDetail = try await productUseCase.fetchProductDetail(id: id)
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
} 
