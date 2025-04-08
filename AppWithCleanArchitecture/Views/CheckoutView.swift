import SwiftUI

struct CheckoutView: View {
    let total: Double
    @State private var selectedPaymentMethod = PaymentMethod.creditCard
    @State private var isProcessing = false
    
    enum PaymentMethod: String, CaseIterable {
        case creditCard = "Credit Card"
        case applePay = "Apple Pay"
        case paypal = "PayPal"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Payment Methods
                VStack(alignment: .leading, spacing: 16) {
                    Text("Payment Method")
                        .font(.headline)
                    
                    ForEach(PaymentMethod.allCases, id: \.self) { method in
                        PaymentMethodButton(
                            method: method,
                            isSelected: selectedPaymentMethod == method,
                            action: { selectedPaymentMethod = method }
                        )
                    }
                }
                
                // Order Summary
                VStack(alignment: .leading, spacing: 16) {
                    Text("Order Summary")
                        .font(.headline)
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Total Amount")
                            Spacer()
                            Text("$\(String(format: "%.2f", total))")
                                .fontWeight(.bold)
                        }
                        
                        HStack {
                            Text("Processing Fee")
                            Spacer()
                            Text("$0.00")
                                .fontWeight(.bold)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Total")
                                .font(.headline)
                            Spacer()
                            Text("$\(String(format: "%.2f", total))")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Pay Button
                Button(action: {
                    processPayment()
                }) {
                    if isProcessing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Pay Now")
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isProcessing ? Color.blue.opacity(0.8) : Color.blue)
                .cornerRadius(12)
                .disabled(isProcessing)
            }
            .padding()
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func processPayment() {
        isProcessing = true
        // Simulate payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessing = false
            // Handle success/failure
        }
    }
}

struct PaymentMethodButton: View {
    let method: CheckoutView.PaymentMethod
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray)
                
                Image(systemName: paymentIcon)
                    .font(.title2)
                
                Text(method.rawValue)
                    .font(.body)
                
                Spacer()
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var paymentIcon: String {
        switch method {
        case .creditCard: return "creditcard"
        case .applePay: return "apple.logo"
        case .paypal: return "dollarsign.circle"
        }
    }
} 