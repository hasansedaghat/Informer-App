//
//  ServerRequest.swift
//  Fanap
//
//  Created by Hasan Sedaghat on 1/30/18.
//  Copyright © 2018 Hasan Sedaghat. All rights reserved.
//

import UIKit
class ServerRequest: NSObject,URLSessionDelegate {
    static let shared = ServerRequest()

    let baseURL = "https://secured.2local.io/"
    static func processResponse(response: URLResponse?, data: Data?) -> (status: Bool,statusCode: Int?, message: String?) {
        let httpResponse = response as? HTTPURLResponse
        if data != nil {
            if httpResponse?.statusCode == 200 {
                do {
                    let result = try JSONDecoder().decode(Result.self, from: data!)
                    if result.code != 200{
                        if result.code == 1 {
                            return(true,200,result.message)
                        }
                        else {
                            return(false,(result.code ?? 0),result.message)
                        }
                    }
                    else {
                        return(true,200,result.message)
                    }
                }
                catch {
                    return(false,-1,"Failed To Parse Data From Server")
                }
            }
            else {
                return(false,httpResponse?.statusCode,"Error Code: \(httpResponse?.statusCode ?? 0)")
            }
        }
        else {
            return(false,httpResponse?.statusCode,"SESSION DATA IS NIL")
        }
    }
    
    func login(email:String,password:String, completion: @escaping (Data?, URLResponse?,Error?) -> Void) {
        let url = URL(string:baseURL + "auth/login")
        print("\(url!)")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["email":email.toBase64(),"password":password.toBase64()], options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request , completionHandler: completion)
            .resume()
    }
    
    func getTransferOrderDetail(userId:String, completion: @escaping (Data?, URLResponse?,Error?) -> Void) {
        var url = URL(string:baseURL + "transfer/get-transfer-order-details")
        url?.appending("user_id", value: userId)
        print("\(url!)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request , completionHandler: completion)
            .resume()
    }
    
}
