import SwiftUI

struct AuthView: View {
    @State private var isLogin = true
    @State private var username = "emilys"
    @State private var email = "emilys"
    @State private var password = "emilyspass"
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text(isLogin ? "Welcome Back" : "Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                TextField("Username", text: $username)
                    .textFieldStyle(ModernTextFieldStyle())
                
                if !isLogin {
                    TextField("Email", text: $email)
                        .textFieldStyle(ModernTextFieldStyle())
                }
                
                SecureField("Password", text: $password)
                    .textFieldStyle(ModernTextFieldStyle())
            }
            .padding(.horizontal)
            
            if let error = authViewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                Task {
                    if isLogin {
                        await authViewModel.login(username: username, password: password)
                    } else {
                        await authViewModel.signup(username: username, email: email, password: password)
                    }
                }
            }) {
                Text(isLogin ? "Login" : "Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(authViewModel.isLoading)
            .opacity(authViewModel.isLoading ? 0.5 : 1)
            
            Button(action: {
                isLogin.toggle()
            }) {
                Text(isLogin ? "Don't have an account? Sign Up" : "Already have an account? Login")
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

struct ModernTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.1))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
} 
