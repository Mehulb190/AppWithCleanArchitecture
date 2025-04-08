import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = DependencyContainer.shared.makeProductViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Sticky Search Bar
            SearchBar(text: $viewModel.searchQuery) {
                Task {
                    await viewModel.refresh()
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .onChange(of: viewModel.searchQuery) { newValue in
                Task {
                    if !newValue.isEmpty {
                        await viewModel.search()
                    }
                }
            }
            
            ScrollView {
                if viewModel.products.isEmpty && viewModel.isLoading {
                    ProgressView("Loading products...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.products) { product in
                            NavigationLink(destination: ProductDetailView(product: product)) {
                                ProductCard(product: product)
                                    .onAppear {
                                        if product == viewModel.products.last {
                                            Task {
                                                await viewModel.fetchProducts()
                                            }
                                        }
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
            ToolbarItem(placement: .principal) {
                Text("Products")
                    .font(.headline)
            }
        }
        .background(Color(.systemGray6))
        .task {
            if viewModel.products.isEmpty {
                await viewModel.fetchProducts()
            }
        }
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        NavigationLink(destination: ProductDetailView(product: product)) {
            VStack(alignment: .leading, spacing: 8) {
                AsyncImage(url: URL(string: product.thumbnail)) { phase in
                    switch phase {
                    case .empty:
                        PlaceholderImageView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure(_):
                        PlaceholderImageView()
                    @unknown default:
                        PlaceholderImageView()
                    }
                }
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(product.title)
                        .font(.headline)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text("$\(String(format: "%.2f", product.price))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
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
                    
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", product.rating))
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                        
                        Text("\(product.stock) in stock")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(product.stock < 10 ? .red : .green)
                    }
                    .font(.caption)
                    
                    Text(product.brand)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PlaceholderImageView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.1))
            
            VStack(spacing: 8) {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(.gray)
                
                Text("No Image")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onClear: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search products...", text: $text)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .focused($isFocused)
            
            if isFocused || !text.isEmpty {
                Button(action: {
                    text = ""
                    onClear()
                    isFocused = false
                }) {
                    Text("Cancel")
                        .foregroundColor(.blue)
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    onClear()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .animation(.easeInOut(duration: 0.2), value: isFocused)
        .animation(.easeInOut(duration: 0.2), value: text)
    }
}
