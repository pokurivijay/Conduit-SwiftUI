//
//  ProfileScreen.swift
//  MyMedium
//
//  Created by neosoft on 17/01/23.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage(AppConst.isSkiped) var isSkiped: Bool = false
    @AppStorage(AppConst.tokan) var tokan: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing:3) {
                    AppNetworkImage(imageUrl: authViewModel.userState?.user?.image ?? "")
                        .frame(width: 120, height: 120)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                    Text(authViewModel.userState?.user?.username ?? "username")
                        .font(.title)
                        .padding(.top)
                    Text(authViewModel.userState?.user?.bio ?? "Bio")
                        .padding(.top,1)
                    Text(authViewModel.userState?.user?.email ?? "Email")
                        .foregroundColor(.gray)
                        .padding(.top,1)
                    Spacer()
                }
            }
            .onAppear {
                AuthServices().getUser(parameters: nil){
                    result in
                    switch result {
                    case .success(let data):
                        withAnimation {
                            authViewModel.userState = data
                        }
                    case .failure(let error):
                        switch error {
                        case .NetworkErrorAPIError(let errorMessage):
                            print(errorMessage)
                        case .BadURL:
                            print("BadURL")
                        case .NoData:
                            print("NoData")
                        case .DecodingErrpr:
                            print("DecodingErrpr")
                        }
                    }
                }
            }
            .navigationBarItems(
                trailing:
                    Button(action: {
                        authViewModel.userState = nil
                        authViewModel.tokan = ""
                        isSkiped = false    
                        tokan = ""
//                        print(authViewModel.userState?.user?.email)
                    }) {
                        Text("Logout")
                    }
            )
            .navigationBarTitle("Profile")
        }
    }
    
    func getProfile() {
        AuthServices().getUser(parameters: nil){
            result in
            switch result {
            case .success(let data):
                withAnimation {
                    authViewModel.userState = data
                }
            case .failure(let error):
                switch error {
                case .NetworkErrorAPIError(let errorMessage):
                    print(errorMessage)
                case .BadURL:
                    print("BadURL")
                case .NoData:
                    print("NoData")
                case .DecodingErrpr:
                    print("DecodingErrpr")
                }
            }
        }
    }
}


struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
            .environmentObject(AuthViewModel()
            )
    }
}
