import Foundation

public extension Service {
    
    public class JSON {
        
        static func encode<T: Encodable>(object: T) -> Data? {
            
            var encoded: Data?
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dataEncodingStrategy = .base64
            encoder.dateEncodingStrategy = .iso8601
            
            do {
                encoded = try encoder.encode(object)
            } catch { print(error) }
            
            return encoded
        }
        
        static func encode<T: Encodable>(objects: [T]) -> Data? {
            
            var encoded: Data?
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dataEncodingStrategy = .base64
            encoder.dateEncodingStrategy = .iso8601
            
            do {
                encoded = try encoder.encode(objects)
            } catch { print(error) }
            
            return encoded
        }
        
        static func decode<T>(_ type: T.Type, from data: Data) -> T? where T : Decodable {
            
            var decoded: T?
            
            let decoder = JSONDecoder()
            decoder.dataDecodingStrategy = .base64
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                decoded = try decoder.decode(type, from: data)
            } catch { print(error) }
            
            return decoded
        }
        
        static func decode<T>(_ type: [T].Type, from data: Data) -> [T]? where T : Decodable {
            
            var decoded: [T]?
            
            let decoder = JSONDecoder()
            decoder.dataDecodingStrategy = .base64
            decoder.dateDecodingStrategy = .iso8601
            
            do {
                decoded = try decoder.decode(type, from: data)
            } catch { print(error) }
            
            return decoded
        }
    }
}
