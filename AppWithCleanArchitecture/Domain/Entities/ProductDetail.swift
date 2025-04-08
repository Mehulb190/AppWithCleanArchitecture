import Foundation

struct ProductDetail: Identifiable, Equatable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: String
    let images: [String]
    let tags: [String]
    let sku: String
    let weight: Double
    let dimensions: ProductDimensions
    let warrantyInformation: String
    let shippingInformation: String
    let availabilityStatus: String
    let reviews: [ProductReview]
    let returnPolicy: String
    let minimumOrderQuantity: Int
    let meta: ProductMeta
    
    var discountedPrice: Double {
        return price * (1 - discountPercentage / 100)
    }
}

struct ProductDimensions: Equatable {
    let width: Double
    let height: Double
    let depth: Double
}

struct ProductReview: Identifiable, Equatable {
    let id = UUID()
    let rating: Int
    let comment: String
    let date: Date
    let reviewerName: String
    let reviewerEmail: String
}

struct ProductMeta: Equatable {
    let createdAt: Date
    let updatedAt: Date
    let barcode: String
    let qrCode: String
} 
