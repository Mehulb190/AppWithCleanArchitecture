class CartRepository: ICartRepository {
    private let apiService: IAPIService
    
    init(apiService: IAPIService = APIService()) {
        self.apiService = apiService
    }
    
    func fetchCart() async throws -> Cart {
        let cartDTO: CartDTO = try await apiService.get(endpoint: "/carts/1")
        return cartDTO.toDomain()
    }
    
    func updateCart(products: [CartProduct]) async throws -> Cart {
        let updateDTO = UpdateCartDTO(products: products.map { 
            UpdateCartProductDTO(id: $0.id, quantity: $0.quantity) 
        })
        let cartDTO: CartDTO = try await apiService.put(endpoint: "/carts/1", body: updateDTO)
        return cartDTO.toDomain()
    }
} 