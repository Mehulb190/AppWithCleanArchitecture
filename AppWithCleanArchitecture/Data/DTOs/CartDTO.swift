struct CartDTO: Codable {
    let id: Int
    let products: [CartProductDTO]
    let total: Double
    let discountedTotal: Double
    let totalProducts: Int
    let totalQuantity: Int
    let userId: Int
    
    func toDomain() -> Cart {
        return Cart(
            id: id,
            products: products.map { $0.toDomain() },
            total: total,
            discountedTotal: discountedTotal,
            totalProducts: totalProducts,
            totalQuantity: totalQuantity
        )
    }
}

struct CartProductDTO: Codable {
    let id: Int
    let title: String
    let price: Double
    let quantity: Int
    let total: Double
    let discountPercentage: Double
    
    func toDomain() -> CartProduct {
        return CartProduct(
            id: id,
            title: title,
            price: price,
            quantity: quantity,
            total: total,
            discountPercentage: discountPercentage
        )
    }
}

struct UpdateCartDTO: Codable {
    let products: [UpdateCartProductDTO]
}

struct UpdateCartProductDTO: Codable {
    let id: Int
    let quantity: Int
} 
