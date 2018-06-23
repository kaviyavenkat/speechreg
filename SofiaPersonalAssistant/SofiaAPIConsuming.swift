//
//  SofiaAPIConsuming.swift
//  NewSTTandTTS
//
//  Created by muruganandam on 12/06/18.
//  Copyright © 2018 prematix. All rights reserved.
//

import Foundation

public class SofiaAPIConsuming : NSObject{
  public  static let sharedInstance = SofiaAPIConsuming()
   public func GettingResponse(query: String, tooken: String, withCompletionHandler:@escaping (_ result:String) -> Void)

    {
        
        var conversationId: String? = ""
        print(conversationId!)
        let Query = query
        print(Query)
        let token = tooken
        print(token)
        let timezone = ""
        print(timezone)
        var responseval : String? = ""
        
        let idvalue = UserDefaults.standard.string(forKey: "conversationId")
        print("the idValue is \(String(describing: idvalue))")
        if idvalue == nil {
            conversationId = ""
        } else {
            conversationId = idvalue
        }
        UserDefaults.standard.removeObject(forKey: "conversationId")
        UserDefaults.standard.synchronize()
        
        let user = [
            "token" : token,
            "timezone" : timezone
        ]
        let json = [
            "query" : Query,
            "user" : user,
            "conversationId" : conversationId!
            ] as [String : Any]
        print("The json value is ",json)
        
        
        let Url = String(format: "https://qadsapi.wittyparrot.com/sofia-bot/dsapi/sofia/converse")
        guard let serviceUrl = URL(string: Url) else { return }
        
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: json, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let requestTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if(error != nil) {
               withCompletionHandler("")
            }else
            {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    print("The json value si ",json as Any)
                    responseval = json.value(forKey: "response") as? String
                    let conversationresponceval = json.value(forKey: "conversationId")
                    print("The response values is ",responseval as Any)
                    print("The conversation val is ",conversationresponceval as Any)
                    UserDefaults.standard.set(conversationresponceval, forKey: "conversationId")
                    UserDefaults.standard.synchronize()
                    withCompletionHandler(responseval!)
                }catch {
                    withCompletionHandler(responseval!)
                }
            }
        }
        requestTask.resume()
    }

}

