//
//  TradeLimits.swift
//  Blockchain
//
//  Created by Alex McGregor on 8/29/18.
//  Copyright © 2018 Blockchain Luxembourg S.A. All rights reserved.
//

import Foundation

struct TradeLimits {
    let currency: String
    let minOrder: Decimal
    let maxOrder: Decimal
    let maxPossibleOrder: Decimal
    let daily: Limit?
    let weekly: Limit?
    let annual: Limit?
}

extension TradeLimits {
    var maxTradableToday: Decimal {
        return daily?.available ?? maxPossibleOrder
    }
}

extension TradeLimits: Decodable {
    enum CodingKeys: String, CodingKey {
        case currency
        case minOrder
        case maxOrder
        case maxPossibleOrder
        case daily
        case weekly
        case annual
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        currency = try values.decode(String.self, forKey: .currency)
        minOrder = try values.decode(String.self, forKey: .minOrder).toDecimal()
        maxOrder = try values.decode(String.self, forKey: .maxOrder).toDecimal()
        maxPossibleOrder = try values.decode(String.self, forKey: .maxPossibleOrder).toDecimal()

        daily = try values.decodeIfPresent(Limit.self, forKey: .daily)
        weekly = try values.decodeIfPresent(Limit.self, forKey: .weekly)
        annual = try values.decodeIfPresent(Limit.self, forKey: .annual)
    }
}

extension String {
    
    enum ConversionError: Error {
        case generic
    }
    
    func toDecimal() throws -> Decimal {
        guard let result = Decimal(string: self) else {
            throw ConversionError.generic
        }
        return result
    }
}
