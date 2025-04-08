import Foundation

struct ProductResponseDTO: Codable {
    let products: [ProductDTO]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ProductDTO: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Double
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String?
    let category: String
    let thumbnail: String
    let images: [String]
    
    func toDomain() -> Product {
        return Product(
            id: id,
            title: title,
            description: description,
            price: price,
            discountPercentage: discountPercentage,
            rating: rating,
            stock: stock,
            brand: brand ?? "Unknown",
            category: category,
            thumbnail: thumbnail,
            images: images
        )
    }
}

struct ProductDimensionsDTO: Codable {
    let width: Double
    let height: Double
    let depth: Double
    
    func toDomain() -> ProductDimensions {
        return ProductDimensions(
            width: width,
            height: height,
            depth: depth
        )
    }
}

struct ProductReviewDTO: Codable {
    let rating: Int
    let comment: String
    let date: String
    let reviewerName: String
    let reviewerEmail: String
    
    func toDomain() -> ProductReview {
        return ProductReview(
            rating: rating,
            comment: comment,
            date: ISO8601DateFormatter().date(from: date) ?? Date(),
            reviewerName: reviewerName,
            reviewerEmail: reviewerEmail
        )
    }
} 
