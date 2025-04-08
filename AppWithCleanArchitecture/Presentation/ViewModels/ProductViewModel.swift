import Foundation

@MainActor
class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchQuery = ""
    
    private let productUseCase: IProductUseCase
    private var currentPage = 0
    private let pageSize = 20
    
    init(productUseCase: IProductUseCase = ProductUseCase(repository: ProductRepository())) {
        self.productUseCase = productUseCase
    }
    
    func fetchProducts() async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        
        do {
            let newProducts = try await productUseCase.fetchProducts(
                skip: currentPage * pageSize,
                limit: pageSize
            )
            products.append(contentsOf: newProducts)
            currentPage += 1
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func search() async {
        guard !searchQuery.isEmpty else {
            await refresh()
            return
        }
        
        isLoading = true
        error = nil
        
        do {
            products = try await productUseCase.searchProducts(query: searchQuery)
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func refresh() async {
        currentPage = 0
        products = []
        await fetchProducts()
    }
} 
