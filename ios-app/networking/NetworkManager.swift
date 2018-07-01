//
//  NetworkManager.swift
//  Hausa
//
//  Created by Emre Can Bolat on 11.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit
import SystemConfiguration

class NetworkManager {
    
    let responseHandler = ResponseHandler()
    let url = URL(string: "https://maganar-hannu.herokuapp.com/")
    
    func checkNetworkAvailability() -> ReachabilityStatus {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return .unknown
        }
        return ReachabilityStatus(reachabilityFlags: flags)
    }
    
    func sendData(_ data: HNObject) {
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody =  data.serializeToJSON().get()
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
            if responseData == nil { return }
            self.responseHandler.handleMessage(JSONObject(json: String(data: responseData!, encoding: String.Encoding.utf8)!))
            
        })
        task.resume()
    }
    
    func requestDateOfServerDB() {
        sendData(HN_requestDatabaseDate())
    }
    
    func fetchImageFromUrl(_ fileName: String, _ completionHandler: @escaping () -> Void?) {
        let filename = fileName.components(separatedBy: ".")
        let request = NSMutableURLRequest(url: URL(string: "https://maganar-hannu.herokuapp.com/images/" + filename[0])!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (responseData: Data?, response: URLResponse?, error: Error?) in
            if responseData != nil && error == nil {
                if let imageData = responseData {
                    self.saveImage(fileName, image: UIImage(data: imageData)!)
                }
                completionHandler()
            }
        })
        task.resume()
    }
    
    private func saveImage(_ fileName: String, image: UIImage) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsURL.appendingPathComponent(fileName)
        if let pngImageData = UIImagePNGRepresentation(image) {
            do {
                try pngImageData.write(to: fileURL, options: .atomic)
            } catch { print("Could not save image to file!")}
        }
    }
}
