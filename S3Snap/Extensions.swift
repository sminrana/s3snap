/**
 * ***********************************************************************
 *  S3 Snap CONFIDENTIAL
 *   __________________
 *
 * Copyright 2022 S3 Snap
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of S3 Snap and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to S3 Snap
 * and its suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from S3 Snap.
 * www.s3snap.com
 *
 */


import Foundation
import Cocoa
import Alamofire
import SwiftyJSON

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    public static func fileName() -> String {
        let date = Date();
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let fileName = "screenshot-" + dateFormatter.string(from: date) + ".png"
        
        return fileName
    }
}

extension NSObject {
    public func uploadToServer(fileName: String, fileContents: Data) {
        var parameters : [String: String] = [:]
        parameters["auth_user"] = "479dfd0e"
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            multipartFormData.append(fileContents, withName: "file", fileName: fileName, mimeType: "image/png")
        }, to: "API URL to upload image to the server")
        .responseString(completionHandler:  { res in
            print(res)
        })
        .response(completionHandler: { response in
            if let j = response.data {
                do {
                    let json = try JSON(data: j)
                    let url = json["url"]
                    let urlString = url.rawValue as! String
                    print(urlString)
                    let clipboard = NSPasteboard.general.setString(urlString, forType: .string)

                    // Open the URL on the browser
                    let u = URL(string: urlString)!
                    NSWorkspace.shared.open(u)
                } catch {
                    print(error)
                }
            }
        })
    }
}

extension NSViewController {
    public func closeWindow() {
        self.view.window?.close()
    }
}
