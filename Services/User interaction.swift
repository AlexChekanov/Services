import Foundation

public extension Service {
    
    struct UserInteraction {
        
        enum ViewState {
            case reading
            case editing
            case rearrangement
            
            mutating func next() {
                switch self {
                case .reading:
                    self = .editing
                case .editing:
                    self = .rearrangement
                case .rearrangement:
                    self = .reading
                }
            }
        }
    }
}
