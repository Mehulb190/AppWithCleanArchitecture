import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = DependencyContainer.shared.makeCartViewModel()
    @Binding var selectedTab: Int
    @State private var showOrderSummary = false
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
            } else if let cart = viewModel.cart {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(cart.products) { product in
                            CartItemView(
                                product: product,
                                onUpdateQuantity: { newQuantity in
                                    Task {
                                        await viewModel.updateProductQuantity(productId: product.id, newQuantity: newQuantity)
                                    }
                                },
                                onRemove: {
                                    Task {
                                        await viewModel.removeProduct(productId: product.id)
                                    }
                                }
                            )
                        }
                    }
                    .padding()
                }
                
                VStack(spacing: 12) {
                    // Order Summary Button
                    Button(action: {
                        withAnimation {
                            showOrderSummary.toggle()
                        }
                    }) {
                        HStack {
                            Text("Order Summary")
                                .font(.headline)
                            Spacer()
                            Text("$\(String(format: "%.2f", cart.finalTotal))")
                                .font(.headline)
                                .foregroundColor(.blue)
                            Image(systemName: showOrderSummary ? "chevron.down" : "chevron.up")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if showOrderSummary {
                        VStack(spacing: 12) {
                            HStack {
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        showOrderSummary = false
                                    }
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .font(.title3)
                                }
                            }
                            
                            HStack {
                                Text("Subtotal")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("$\(String(format: "%.2f", cart.subtotal))")
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Text("Discount")
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("-$\(String(format: "%.2f", cart.totalDiscount))")
                                    .foregroundColor(.green)
                                    .fontWeight(.medium)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total")
                                    .font(.headline)
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("$\(String(format: "%.2f", cart.finalTotal))")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                    Text("Including VAT")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                    
                    // Checkout Button
                    NavigationLink(destination: CheckoutView(total: cart.finalTotal)) {
                        Text("Proceed to Checkout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
            } else {
                EmptyCartView(selectedTab: $selectedTab)
            }
        }
        .navigationTitle("Cart")
        .task {
            await viewModel.fetchCart()
        }
    }
}

struct CartItemView: View {
    let product: CartProduct
    let onUpdateQuantity: (Int) -> Void
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                // Product Image
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
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                // Product Details
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    // Price Section
                    HStack(alignment: .bottom, spacing: 8) {
                        Text("$\(String(format: "%.2f", product.discountedPrice))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        if product.discountPercentage > 0 {
                            Text("$\(String(format: "%.2f", product.price))")
                                .strikethrough()
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Discount Badge
                    if product.discountPercentage > 0 {
                        Text("\(Int(product.discountPercentage))% OFF")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
                
                Spacer()
                
                // Delete Button
                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .foregroundColor(.red.opacity(0.8))
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.bottom, 12)
            
            Divider()
                .padding(.bottom, 12)
            
            // Quantity Stepper
            HStack {
                Text("Quantity")
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Button(action: {
                        onUpdateQuantity(product.quantity - 1)
                    }) {
                        Image(systemName: "minus")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                    .disabled(product.quantity <= 1)
                    .opacity(product.quantity <= 1 ? 0.5 : 1)
                    
                    Text("\(product.quantity)")
                        .font(.headline)
                        .frame(minWidth: 40)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        onUpdateQuantity(product.quantity + 1)
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct EmptyCartView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "cart")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Your cart is empty")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Browse products and add items to your cart")
                .foregroundColor(.secondary)
            
            Button(action: {
                selectedTab = 0  // Switch to Products tab
            }) {
                HStack {
                    Image(systemName: "bag")
                    Text("Browse Products")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .padding(.top, 20)
            .padding(.horizontal, 40)
        }
    }
} 

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
} 
