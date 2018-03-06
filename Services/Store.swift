import Foundation
import StoreKit
import GeneralExtensions

// App Features

public enum Feature: String {
    
    case iCloud = "com.gestalt.iOS.paid.nonconsumable.icloud"
}

public protocol StoreProductsDelegate {
    var storeProducts: [SKProduct] { get set }
    func fetch(products: [SKProduct])
}

public extension StoreProductsDelegate {
    mutating func fetch(products: [SKProduct]) {
        storeProducts = products
    }
}

// TODO: - Add subscription management
// TODO: - Add consumable management
// TODO: - Add receipt validation

public extension Service {
    
    public class Store: NSObject {
        
        public static let sharedInstance: Store = Store()
        private override init() {}
        
        var storeProductsDelegate: StoreProductsDelegate?
        
        var canMakePayments = SKPaymentQueue.canMakePayments()
        
        var products: [SKProduct] = [] {
            didSet {
                storeProductsDelegate?.fetch(products: products)
                products.forEach { print($0.productIdentifier, $0.localizedTitle, $0.priceLocale) }
            }
        }
        
        private let paymentQueue = SKPaymentQueue.default()
        
        lazy var productIdentifiers: [String] = {
            var identifiers: [String] = []
            
            if let fileUrl = Bundle.main.url(forResource: "Paid", withExtension: "plist"){
                let products = NSArray(contentsOf: fileUrl)
                for product in products as! [String]{ identifiers.append(product) }
            }
            return identifiers
        }()
        
        func setup(_ completionHandler: @escaping (Bool) -> Void){
            if canMakePayments {
                paymentQueue.add(self)
                completionHandler(true)
                return
            }
            completionHandler(false)
        }
        
        // MARK: - ProductsRequest
        func requestProducts(){
            
            let productIdentifiers = NSSet(array: self.productIdentifiers) as! Set<String>
            
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        }
        
        // MARK: - Payment Request
        func createPaymentRequest(for quantity: Int = 1, product: SKProduct){
            guard self.productIdentifiers.contains(product.productIdentifier) else { return }
            
            let payment = SKMutablePayment(product: product)
            payment.quantity = quantity
            paymentQueue.add(payment)
        }
        
        // MARK: - Restore Purchases
        func restorePurchases () {
            paymentQueue.restoreCompletedTransactions()
        }
        
        // MARK: - Purchase Confirmation
        public func confirmOwnership(of feature: Feature) -> Bool {
            
            return Defaults.bool(forKey: feature.rawValue)
            
            //TODO: Include ownership restoration if not
        }
        
        private func setFeatureOwnership(of productIdentifier: String){
            Defaults.set(true, forKey: productIdentifier)
            Defaults.synchronize()
            
            // TODO: Consumable and Subscription!
        }
        
        // MARK: - Lock Functionality
        private func invalidateFeatureOwnership(of productIdentifier: String){
            Defaults.set(false, forKey: productIdentifier)
            Defaults.synchronize()
        }
    }
}

// MARK: - SKProductsRequestDelegate
extension Service.Store: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("Total products: \(response.products.count)")
        print("Response — Invalid Product Identifiers: \n \(response.invalidProductIdentifiers)")
        response.products.forEach { print($0.localizedTitle, $0.localizedDescription, $0.priceLocale) }
        self.products = response.products
        for product in response.products { print(product.localizedDescription) }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        // TODO: - Handle errors
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        // TODO: - Handle
    }
}

// MARK: - SKPaymentTransactionObserver
extension Service.Store: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            
            // TODO: - Handle appropriate transaction state
            switch $0.transactionState {
                
            case .purchasing:
                print("purchasing")
            case .purchased:
                paymentQueue.finishTransaction($0)
            case .failed:
                print($0.error?.localizedDescription ?? "")
                paymentQueue.finishTransaction($0)
            case .restored:
                print("restored")
            case .deferred:
                print("deffered")
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        //
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        //
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedDownloads downloads: [SKDownload]) {
        //
    }
    
    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        //
        print("paymentQueueRestoreCompletedTransactionsFinished")
    }
}

public extension SKPaymentTransactionState {
    
    func status() -> String {
        
        switch self {
        case .deferred:   return "deferred"
        case .purchasing: return "purchasing"
        case .purchased:  return "purchased"
        case .failed:     return "failed"
        case .restored:   return "restored"
        }
        
    }
}
