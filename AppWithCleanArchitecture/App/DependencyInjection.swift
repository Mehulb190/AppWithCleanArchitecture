class DependencyContainer {
    static let shared = DependencyContainer()
    
    lazy var apiService: IAPIService = APIService()
    
    // Auth
    lazy var authRepository: IAuthRepository = AuthRepository(apiService: apiService)
    lazy var authUseCase: IAuthUseCase = AuthUseCase(repository: authRepository)
    
    // Products
    lazy var productRepository: IProductRepository = ProductRepository(apiService: apiService)
    lazy var productUseCase: IProductUseCase = ProductUseCase(repository: productRepository)
    
    // Cart
    lazy var cartRepository: ICartRepository = CartRepository(apiService: apiService)
    lazy var cartUseCase: ICartUseCase = CartUseCase(repository: cartRepository)
    
    @MainActor func makeAuthViewModel() -> AuthViewModel {
        return AuthViewModel(authUseCase: authUseCase)
    }
    
    @MainActor func makeProductViewModel() -> ProductViewModel {
        return ProductViewModel(productUseCase: productUseCase)
    }
    
    @MainActor func makeCartViewModel() -> CartViewModel {
        return CartViewModel(cartUseCase: cartUseCase)
    }
} 
