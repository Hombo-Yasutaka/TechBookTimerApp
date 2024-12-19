//
//  BookSearchRequest.swift
//  TechBookTimerApp
//
//  Created by 本坊康孝 on 2024/12/17.
//

import Foundation

struct BookResponse: Codable {
    let onix: Onix
    let hanmoto: Hanmoto
    let summary: Summary
}

struct Onix: Codable {
    let collateralDetail: CollateralDetail?
    let recordReference: String?
    let notificationType: String?
    let productIdentifier: ProductIdentifier?
    let descriptiveDetail: DescriptiveDetail?
    let publishingDetail: PublishingDetail?
    let productSupply: ProductSupply?

    enum CodingKeys: String, CodingKey {
        case collateralDetail = "CollateralDetail"
        case recordReference = "RecordReference"
        case notificationType = "NotificationType"
        case productIdentifier = "ProductIdentifier"
        case descriptiveDetail = "DescriptiveDetail"
        case publishingDetail = "PublishingDetail"
        case productSupply = "ProductSupply"
    }
}

struct CollateralDetail: Codable {
    // このstructは空のままで大丈夫です
    // JSONの構造を反映するために定義しておきます
}

struct ProductIdentifier: Codable {
    let productIDType: String?
    let idValue: String?

    enum CodingKeys: String, CodingKey {
        case productIDType = "ProductIDType"
        case idValue = "IDValue"
    }
}

struct DescriptiveDetail: Codable {
    let titleDetail: TitleDetail?
    let contributor: [Contributor]?

    enum CodingKeys: String, CodingKey {
        case titleDetail = "TitleDetail"
        case contributor = "Contributor"
    }
}

struct TitleDetail: Codable {
    let titleType: String?
    let titleElement: TitleElement?

    enum CodingKeys: String, CodingKey {
        case titleType = "TitleType"
        case titleElement = "TitleElement"
    }
}

struct TitleElement: Codable {
    let titleElementLevel: String?
    let titleText: TitleText?

    enum CodingKeys: String, CodingKey {
        case titleElementLevel = "TitleElementLevel"
        case titleText = "TitleText"
    }
}

struct TitleText: Codable {
    let collationKey: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case collationKey = "collationkey"
        case content = "content"
    }
}

struct Contributor: Codable {
    let sequenceNumber: String?
    let contributorRole: [String]?
    let personName: PersonName?

    enum CodingKeys: String, CodingKey {
        case sequenceNumber = "SequenceNumber"
        case contributorRole = "ContributorRole"
        case personName = "PersonName"
    }
}

struct PersonName: Codable {
    let content: String?
    let collationKey: String?

    enum CodingKeys: String, CodingKey {
        case content = "content"
        case collationKey = "collationkey"
    }
}

struct PublishingDetail: Codable {
    let imprint: Imprint?
    let publishingDate: [PublishingDate]?

    enum CodingKeys: String, CodingKey {
        case imprint = "Imprint"
        case publishingDate = "PublishingDate"
    }
}

struct Imprint: Codable {
    let imprintName: String?

    enum CodingKeys: String, CodingKey {
        case imprintName = "ImprintName"
    }
}

struct PublishingDate: Codable {
    let publishingDateRole: String?
    let date: String?

    enum CodingKeys: String, CodingKey {
        case publishingDateRole = "PublishingDateRole"
        case date = "Date"
    }
}

struct ProductSupply: Codable {
    let supplyDetail: SupplyDetail?

    enum CodingKeys: String, CodingKey {
        case supplyDetail = "SupplyDetail"
    }
}

struct SupplyDetail: Codable {
    let productAvailability: String?
    let price: [Price]?

    enum CodingKeys: String, CodingKey {
        case productAvailability = "ProductAvailability"
        case price = "Price"
    }
}

struct Price: Codable {
    let priceType: String?
    let currencyCode: String?
    let priceAmount: String?

    enum CodingKeys: String, CodingKey {
        case priceType = "PriceType"
        case currencyCode = "CurrencyCode"
        case priceAmount = "PriceAmount"
    }
}

struct Hanmoto: Codable {
    let dateCreated: String?
    let dateShuppan: String?
    let dateModified: String?

    enum CodingKeys: String, CodingKey {
        case dateCreated = "datecreated"
        case dateShuppan = "dateshuppan"
        case dateModified = "datemodified"
    }
}

struct Summary: Codable {
    let isbn: String?
    let title: String?
    let volume: String?
    let series: String?
    let publisher: String?
    let pubdate: String?
    let cover: String?
    let author: String?
}

final class BookSearchRequest {

    func searchBook(keyword: String, completion: @escaping (Result<[BookResponse], Error>) -> Void) {
        let path = "https://api.openbd.jp/v1/get?isbn=\(keyword)"
        APIClient.shared.getRequest(urlString: path) { result in
            switch result {
            case .success(let jsonData):
                // デコード処理
                do {
                    // デコード成功
                    let decoder = JSONDecoder()
                    let response = try decoder.decode([BookResponse].self, from: jsonData)
                    // 整形されたJSONのプリント
                    if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
                       let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                       let prettyPrintedString = String(data: prettyJsonData, encoding: .utf8) {
                        print("GET request successful: \(prettyPrintedString)")
                    } else {
                        print("GET request successful: \(response)")
                    }

                    // 呼び出し元へ取得データを渡す
                    completion(.success(response))
                } catch {
                    // デコード失敗
                    print("JSON Decoding failed: \(error.localizedDescription)")
                    // 呼び出し元へエラーを渡す
                    completion(.failure(error))
                }
            case .failure(let error):
                print("GET request failed: \(error.localizedDescription)")
                // 呼び出し元へエラーを渡す
                    completion(.failure(error))
            }
        }
    }

}

