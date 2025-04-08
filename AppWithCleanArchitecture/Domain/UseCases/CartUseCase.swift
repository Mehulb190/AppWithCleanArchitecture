protocol ICartUseCase {
    func fetchCart() async throws -> Cart
    func updateCart(products: [CartProduct]) async throws -> Cart
}

class CartUseCase: ICartUseCase {
    private let repository: ICartRepository
    
    init(repository: ICartRepository) {
        self.repository = repository
    }
    
    func fetchCart() async throws -> Cart {
        return try await repository.fetchCart()
    }
    
    func updateCart(products: [CartProduct]) async throws -> Cart {
        return try await repository.updateCart(products: products)
    }
} 