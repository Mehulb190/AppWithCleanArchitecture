protocol ICartRepository {
    func fetchCart() async throws -> Cart
    func updateCart(products: [CartProduct]) async throws -> Cart
} 