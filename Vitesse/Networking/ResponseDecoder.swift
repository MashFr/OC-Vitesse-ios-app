//
//  ResponseDecoder.swift
//  Vitesse
//
//  Created by Tony Stark on 06/12/2024.
//
import Foundation

/// A utility that handles decoding raw data into decodable types.
struct ResponseDecoder {
    /// Decodes raw data into a specified Decodable type.
    static func decode<T: Decodable>(
        _ data: Data?,
        to type: T.Type
    ) -> Result<T, Error> {
        guard let data = data else {
            return .failure(APIError.noData)
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch {
            return .failure(error)
        }
    }
}
