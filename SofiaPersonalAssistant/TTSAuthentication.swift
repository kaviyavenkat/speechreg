

import Foundation

class TTSAuthentication {
    
    static let accessTokenUri = "https://api.cognitive.microsoft.com/sts/v1.0/issueToken"
    
    private let apiKey: String
    private var accessToken: String?
    
    //Access token expires every 10 minutes. Renew it every 9 minutes only.
    private static let refreshTokenDuration: Double = 9 * 60
    
    init(apiKey: String) {
        print("The api key value si ",apiKey)
        self.apiKey = apiKey
        self.refreshToken()
    }
    
    func getAccessToken(_ callback: @escaping (String) -> ()) {
        if let token = self.accessToken {
            print("The token value is ",token)
            callback(token)
        } else {
            self.refreshToken({ (token: String) in
                print("The ttk value is ",token)
                callback(token)
            })
        }
    }
    
    private func refreshToken(_ callback: ((String) -> ())? = nil) {
        TTSHttpRequest.submit(withUrl: TTSAuthentication.accessTokenUri, andHeaders: ["Ocp-Apim-Subscription-Key": apiKey]) { [weak self] (c: TTSHttpRequest.Callback) in
            defer {
                // renew the token every specified minutes
                DispatchQueue.global().asyncAfter(deadline: .now() + TTSAuthentication.refreshTokenDuration) {
                    self?.refreshToken()
                }
            }
            guard let data = c.data, let accessToken = String(data: data, encoding: String.Encoding.utf8) else {
                return
            }
            self?.accessToken = accessToken
            print("The access token value sis ",accessToken)
            callback?(accessToken)
        }
    }
}
