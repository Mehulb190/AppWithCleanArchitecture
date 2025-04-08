struct Cart: Identifiable, Equatable {
    let id: Int
    var products: [CartProduct]
    let total: Double
    let discountedTotal: Double
    let totalProducts: Int
    let totalQuantity: Int
    
    // Computed properties for cart totals
    var subtotal: Double {
        products.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    var totalDiscount: Double {
        products.reduce(0) { $0 + ($1.price * Double($1.quantity) - $1.discountedPrice * Double($1.quantity)) }
    }
    
    var finalTotal: Double {
        subtotal - totalDiscount
    }
}

struct CartProduct: Identifiable, Equatable {
    let id: Int
    let title: String
    let price: Double
    let quantity: Int
    let total: Double
    let discountPercentage: Double
    
    var discountedPrice: Double {
        return price * (1 - discountPercentage / 100)
    }
    
    var thumbnail: String {
        return "https://cdn.dummyjson.com/product-images/\(id)/thumbnail.jpg"
    }
} 