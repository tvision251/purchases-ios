//
//  Copyright RevenueCat Inc. All Rights Reserved.
//
//  Licensed under the MIT License (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      https://opensource.org/licenses/MIT
//
//  PurchasesDeprecation.swift
//
//  Created by Joshua Liebowitz on 10/18/21.

import Foundation
import RevenueCat

// Protocol that enables us to call deprecated methods without triggering warnings.
public protocol PurchasesDeprecatable {

    var allowSharingAppStoreAccount: Bool { get set }

    static func addAttributionData(_ data: [String: Any], fromNetwork network: AttributionNetwork)
    static func addAttributionData(_ data: [String: Any],
                                   from network: AttributionNetwork,
                                   forNetworkUserId networkUserId: String?)
    func createAlias(_ alias: String, _ completion: ((CustomerInfo?, Error?) -> Void)?)
    func identify(_ appUserID: String, _ completion: ((CustomerInfo?, Error?) -> Void)?)
    func reset(completion: ((CustomerInfo?, Error?) -> Void)?)

}

class PurchasesDeprecation: PurchasesDeprecatable {

    let purchases: Purchases

    init(purchases: Purchases) {
        self.purchases = purchases
    }

    @available(*, deprecated)
    var allowSharingAppStoreAccount: Bool {
        set {
            purchases.allowSharingAppStoreAccount = newValue
        }
        get {
            return purchases.allowSharingAppStoreAccount
        }
    }

    @available(*, deprecated)
    static func addAttributionData(_ data: [String: Any], fromNetwork network: AttributionNetwork) {
        Purchases.addAttributionData(data, fromNetwork: network)
    }

    @available(*, deprecated)
    static func addAttributionData(_ data: [String : Any],
                                   from network: AttributionNetwork,
                                   forNetworkUserId networkUserId: String?) {
        Purchases.addAttributionData(data, from: network, forNetworkUserId: networkUserId)
    }

    @available(*, deprecated)
    func createAlias(_ alias: String, _ completion: ((CustomerInfo?, Error?) -> Void)?) {
        purchases.createAlias(alias, completion)
    }

    @available(*, deprecated)
    func identify(_ appUserID: String, _ completion: ((CustomerInfo?, Error?) -> Void)?) {
        purchases.identify(appUserID, completion)
    }

    @available(*, deprecated)
    func reset(completion: ((CustomerInfo?, Error?) -> Void)?) {
        purchases.reset(completion: completion)
    }

}

extension Purchases {

    /**
     * Computed property you should use if you receive deprecation warnings. This is a proxy for a Purchases object.
     * By calling `.deprecated` you will have access to the same API, but it won't trigger a deprecation.
     * If you need to set a property that is deprecated, you'll need to create a var in your test to hold a copy of
     * the `deprecated` object. This is because the `deprecated` property is computed and so you cannot mutate it.
     * e.g.:
     * var deprecatedVarObject = purchases.deprecated
     * deprecatedVarObject.allowSharingAppStoreAccount = true
     */
    var deprecated: PurchasesDeprecatable {
        return PurchasesDeprecation(purchases: self)
    }

    /**
     * Computed property you should use if you receive deprecation warnings. This is a proxy for the Purchases class.
     * By calling `.deprecated` you will have access to the same API, but it won't trigger a deprecation.
     */
    static var deprecated: PurchasesDeprecatable.Type {
        return PurchasesDeprecation.self
    }

}
