//
//  APIKey.swift
//  TodaysWeather
//
//  Created by 서녕 on 2022/06/10.
//

import Foundation

extension Bundle {
    var client_id: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("Couldn't find file 'SecretKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "CLIENT_ID") as? String else {
                fatalError("Couldn't find key 'CLIENT_ID' in 'SecretKey.plist'.")
            }
            return value
        }
    }
    
    var client_secret: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "SecretKey", ofType: "plist") else {
                fatalError("Couldn't find file 'SecretKey.plist'.")
            }
            let plist = NSDictionary(contentsOfFile: filePath)
            
            guard let value = plist?.object(forKey: "CLIENT_SECRET") as? String else {
                fatalError("Couldn't find key 'CLIENT_SECRET' in 'SecretKey.plist'.")
            }
            return value
        }
    }
}
