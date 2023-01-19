//
//  TrandingArticleScreen.swift
//  MyMedium
//
//  Created by neosoft on 16/01/23.
//

import SwiftUI

struct TrandingArticleScreen: View {
    
    @State var articleData: TrandingArticles? = nil
    @State private var presentedScreen = NavigationPath()
    
    var body: some View {
        NavigationStack (path: $presentedScreen) {
            List(articleData?.articles ?? []) { article in
                Button (action: {
                    let data = SelectedArticleScreenType(selectedArticle: article)
                    presentedScreen.append(data)
                }, label: {
                    HStack {
                        ArticleRow(article: article)
                    }
                })
                .buttonStyle(.plain)
            }
            .navigationDestination(for: SelectedArticleScreenType.self) { type in
                ArticleDetailViewScreen(article: type.selectedArticle!)
            }
            .navigationBarTitle("Articles")
            .onAppear {
                getUserList()
            }
        }
    }
    
    func getUserList() {
        print("Dping API call")
        let parameters: [String: Any] = [
            "limit":"5"
        ]
        ArticleServices().getTrandingArticle(parameters: parameters){
            result in
            switch result {
            case .success(let data):
                withAnimation {
                    articleData = data
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
    
    struct TrandingArticleScreen_Previews: PreviewProvider {
        static var previews: some View {
            TrandingArticleScreen()
        }
    }
}
