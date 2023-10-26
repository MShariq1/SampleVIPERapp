//
//  HomeEntity.swift
//  SampleViperArch
//
//  Created by Shariq on 2023-10-12.
//

class HomeModel {
    var universityName: String
    var countryName: String
    var web_pages: [String]

    init(data: [String: Any]) {
        universityName = data["name"] as? String ?? ""
        countryName = data["country"] as? String ?? ""
        web_pages = data["web_pages"] as? [String] ?? []
    }
}
