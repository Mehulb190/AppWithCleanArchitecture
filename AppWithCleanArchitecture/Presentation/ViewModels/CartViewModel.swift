import Foundation

@MainActor
class CartViewModel: ObservableObject {
    @Published var cart: Cart?
    @Published var isLoading = false
    @Published var error: String?
    
    private let cartUseCase: ICartUseCase
    
    init(cartUseCase: ICartUseCase = CartUseCase(repository: CartRepository())) {
        self.cartUseCase = cartUseCase
    }
    
    func fetchCart() async {
        isLoading = true
        error = nil
        
        do {
            cart = try await cartUseCase.fetchCart()
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func updateProductQuantity(productId: Int, newQuantity: Int) async {
        guard var currentCart = cart else { return }
        
        if newQuantity <= 0 {
            currentCart.products.removeAll { $0.id == productId }
        } else {
            if let index = currentCart.products.firstIndex(where: { $0.id == productId }) {
                let updatedProduct = CartProduct(
                    id: currentCart.products[index].id,
                    title: currentCart.products[index].title,
                    price: currentCart.products[index].price,
                    quantity: newQuantity,
                    total: currentCart.products[index].price * Double(newQuantity),
                    discountPercentage: currentCart.products[index].discountPercentage
                )
                currentCart.products[index] = updatedProduct
            }
        }
        
        do {
            cart = try await cartUseCase.updateCart(products: currentCart.products)
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func removeProduct(productId: Int) async {
        await updateProductQuantity(productId: productId, newQuantity: 0)
    }
} 
