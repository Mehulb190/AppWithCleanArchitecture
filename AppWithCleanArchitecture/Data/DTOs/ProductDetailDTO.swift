import Foundation

struct ProductDetailDTO: Codable {
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
    let dimensions: DimensionsDTO
    let warrantyInformation: String
    let shippingInformation: String
    let availabilityStatus: String
    let reviews: [ReviewDTO]
    let returnPolicy: String
    let minimumOrderQuantity: Int
    let meta: MetaDTO
    
    func toDomain() -> ProductDetail {
        return ProductDetail(
            id: id,
            title: title,
            description: description,
            price: price,
            discountPercentage: discountPercentage,
            rating: rating,
            stock: stock,
            brand: brand,
            category: category,
            thumbnail: thumbnail,
            images: images,
            tags: tags,
            sku: sku,
            weight: weight,
            dimensions: dimensions.toDomain(),
            warrantyInformation: warrantyInformation,
            shippingInformation: shippingInformation,
            availabilityStatus: availabilityStatus,
            reviews: reviews.map { $0.toDomain() },
            returnPolicy: returnPolicy,
            minimumOrderQuantity: minimumOrderQuantity,
            meta: meta.toDomain()
        )
    }
}

struct DimensionsDTO: Codable {
    let width: Double
    let height: Double
    let depth: Double
    
    func toDomain() -> ProductDimensions {
        return ProductDimensions(width: width, height: height, depth: depth)
    }
}

struct ReviewDTO: Codable {
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

struct MetaDTO: Codable {
    let createdAt: String
    let updatedAt: String
    let barcode: String
    let qrCode: String
    
    func toDomain() -> ProductMeta {
        return ProductMeta(
            createdAt: ISO8601DateFormatter().date(from: createdAt) ?? Date(),
            updatedAt: ISO8601DateFormatter().date(from: updatedAt) ?? Date(),
            barcode: barcode,
            qrCode: qrCode
        )
    }
} 
