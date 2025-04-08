import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @StateObject private var viewModel = ProductDetailViewModel()
    @State private var selectedImageIndex = 0
    @State private var showReviews = false
    @State private var showAddToCartSheet = false
    @State private var quantity = 1
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                } else if let detail = viewModel.productDetail {
                    // Image Carousel
                    TabView(selection: $selectedImageIndex) {
                        ForEach(detail.images.indices, id: \.self) { index in
                            AsyncImage(url: URL(string: detail.images[index])) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure:
                                    PlaceholderImageView()
                                @unknown default:
                                    PlaceholderImageView()
                                }
                            }
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(height: 300)
                    
                    VStack(spacing: 24) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text(detail.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack {
                                Text(detail.brand)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("SKU: \(detail.sku)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Tags
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(detail.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.blue.opacity(0.1))
                                            .foregroundColor(.blue)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                        }
                        
                        // Price Section
                        VStack(spacing: 12) {
                            HStack(alignment: .center) {
                                Text("$\(String(format: "%.2f", detail.discountedPrice))")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                                
                                if detail.discountPercentage > 0 {
                                    Text("$\(String(format: "%.2f", detail.price))")
                                        .strikethrough()
                                        .foregroundColor(.secondary)
                                    
                                    Text("\(Int(detail.discountPercentage))% OFF")
                                        .font(.callout)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.red)
                                        .cornerRadius(8)
                                }
                            }
                            
                            // Status Indicators
                            HStack(spacing: 16) {
                                // Rating
                                HStack(spacing: 4) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(String(format: "%.1f", detail.rating))
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.yellow.opacity(0.1))
                                .cornerRadius(8)
                                
                                // Stock
                                HStack(spacing: 4) {
                                    Image(systemName: "box.fill")
                                    Text("\(detail.stock) in stock")
                                        .fontWeight(.medium)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(detail.stock < 10 ? Color.red.opacity(0.1) : Color.green.opacity(0.1))
                                .foregroundColor(detail.stock < 10 ? .red : .green)
                                .cornerRadius(8)
                                
                                // Availability Status
                                Text(detail.availabilityStatus)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // Info Cards
                        VStack(spacing: 16) {
                            InfoCard(title: "Description", content: detail.description)
                            
                            InfoCard(title: "Shipping", content: detail.shippingInformation)
                            
                            InfoCard(title: "Warranty", content: detail.warrantyInformation)
                            
                            InfoCard(title: "Return Policy", content: detail.returnPolicy)
                            
                            // Dimensions
                            InfoCard(title: "Specifications", content: """
                                Weight: \(String(format: "%.1f", detail.weight)) kg
                                Dimensions: \(String(format: "%.1f", detail.dimensions.width))cm × \(String(format: "%.1f", detail.dimensions.height))cm × \(String(format: "%.1f", detail.dimensions.depth))cm
                                Minimum Order: \(detail.minimumOrderQuantity) units
                                """)
                        }
                        
                        // Reviews Section
                        VStack(alignment: .leading, spacing: 16) {
                            Button(action: { showReviews.toggle() }) {
                                HStack {
                                    Text("Customer Reviews")
                                        .font(.headline)
                                    Spacer()
                                    Image(systemName: showReviews ? "chevron.up" : "chevron.down")
                                }
                            }
                            
                            if showReviews {
                                ForEach(detail.reviews) { review in
                                    ReviewCard(review: review)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showAddToCartSheet = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "cart.badge.plus")
                        Text("Add")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(20)
                }
            }
        }
        .sheet(isPresented: $showAddToCartSheet) {
            AddToCartSheet(
                product: product,
                quantity: $quantity,
                isPresented: $showAddToCartSheet
            )
        }
        .task {
            await viewModel.fetchProductDetail(id: product.id)
        }
    }
}

struct InfoCard: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct ReviewCard: View {
    let review: ProductReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(review.reviewerName)
                    .font(.headline)
                
                Spacer()
                
                Text(review.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 4) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= review.rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
            
            Text(review.comment)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct AddToCartSheet: View {
    let product: Product
    @Binding var quantity: Int
    @Binding var isPresented: Bool
    @StateObject private var cartViewModel = DependencyContainer.shared.makeCartViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Product Info
                HStack(spacing: 16) {
                    AsyncImage(url: URL(string: product.thumbnail)) { phase in
                        switch phase {
                        case .empty:
                            PlaceholderImageView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            PlaceholderImageView()
                        @unknown default:
                            PlaceholderImageView()
                        }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(product.title)
                            .font(.headline)
                            .lineLimit(2)
                        
                        Text("$\(String(format: "%.2f", product.price))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Quantity Stepper
                VStack(spacing: 8) {
                    Text("Quantity")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            if quantity > 1 {
                                quantity -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(quantity > 1 ? .blue : .gray)
                        }
                        
                        Text("\(quantity)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(minWidth: 40)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            if quantity < product.stock {
                                quantity += 1
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(quantity < product.stock ? .blue : .gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Total
                VStack(spacing: 8) {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text("$\(String(format: "%.2f", product.price * Double(quantity)))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    if product.discountPercentage > 0 {
                        HStack {
                            Text("You save")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("$\(String(format: "%.2f", (product.price * Double(quantity)) * (product.discountPercentage / 100)))")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                Spacer()
                
                // Add to Cart Button
                Button(action: {
                    Task {
                        await cartViewModel.updateProductQuantity(productId: product.id, newQuantity: quantity)
                        isPresented = false
                    }
                }) {
                    Text("Add to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding()
            .navigationTitle("Add to Cart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
} 
