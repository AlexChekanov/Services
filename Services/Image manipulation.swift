import Foundation
import UIKit

public extension Service {
    
    struct ImageManipulation {
        
        static func nsPNGPictureData(from image: UIImage) -> NSData? {
            
            let picture = UIImagePNGRepresentation(image)
            guard picture != nil else { return nil }
            //TODO: Safe picture convertion!
            return picture! as NSData
        }
    }
}
