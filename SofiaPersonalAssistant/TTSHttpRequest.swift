
import Foundation

class TTSHttpRequest {
    
    typealias Callback = (data: Data?, response: URLResponse?, error: Error?)
    
    static func submit(withUrl url: String, andHeaders headers: [String: String]? = nil, andBody body: Data? = nil, _ callback: @escaping (Callback) -> ()) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        headers?.forEach({ (header: (key: String, value: String)) in
            request.setValue(header.value, forHTTPHeaderField: header.key)
        })
        if let body = body {
            request.httpBody = body
        }
        let task = URLSession.shared.dataTask(with: request) { data,response,error in
           
            callback((data,response,error))
            
        }
        task.resume()
    }
}
