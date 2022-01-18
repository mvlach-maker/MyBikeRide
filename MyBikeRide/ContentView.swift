//
//  ContentView.swift
//  MyBikeRide
//
//  Created by Marina Vlachandreas on 2022-01-18.
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
    
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn:Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        
        auth.signIn(withEmail: email, password: password) { [weak self]result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
            // Success
            self?.signedIn = true
            }
        }
    }
    
    
        func signUp(email: String, password: String) {
            
            auth.createUser(withEmail: email, password: password) { [weak self] result, error in
                guard result != nil, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                // Success
                self?.signedIn = true
        
                }
            }
        
    }

}

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
  
        NavigationView {
           
            if viewModel.signedIn {
              Text("You are signed in.")
            }
            else {
                SignInView()
            }
            
        }
        .onAppear(perform: {
            viewModel.signedIn = viewModel.isSignedIn
        })
    }
}

struct SignInView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @State var email = ""
    @State var password = ""
    
    var body: some View {
  
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                VStack {
                    TextField("Email address", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        
                        
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        
                    Button(action: {
                        
                        guard !email.isEmpty, !password.isEmpty else {
                            return
                        }
                        
                        viewModel.signIn(email: email, password: password)
                        
                    }, label: {
                    Text("Sign In")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(8)
                    })
                    
                    NavigationLink("Create Account", destination: SignUpView())
                        .padding()
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Sign In")
    }
}

struct SignUpView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
    @State var email = ""
    @State var password = ""
    
    var body: some View {
  
            VStack {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                VStack {
                    TextField("Email address", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        
                        
                    SecureField("Password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        
                    Button(action: {
                        
                        guard !email.isEmpty, !password.isEmpty else {
                            return
                        }
                        
                        viewModel.signUp(email: email, password: password)
                        
                    }, label: {
                    Text("Create Account")
                            .foregroundColor(Color.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(8)
                    })
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Create Account")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
