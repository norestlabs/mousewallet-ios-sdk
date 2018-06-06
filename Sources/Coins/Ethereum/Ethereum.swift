//
//  Ethereum.swift
//  NRLWalletSDK
//
//  Created by David Bala on 16/05/2018.
//  Copyright © 2018 NoRestLabs. All rights reserved.
//

import Foundation

class NRLEthereum : NRLCoin{
    var privKey: EthereumPrivateKey?
    
    init(seed: Data, fTest: Bool) {
        var network: Network = .main(.ethereum)
        if (fTest) {
            network = .test(.ethereum)
        }
        
        let cointype = network.coinType
        
        super.init(seed: seed,
                   network: network,
                   coinType: cointype,
                   seedKey: "Bitcoin seed",
                   curve: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141")
    }

    override func generatePublickeyFromPrivatekey(privateKey: Data) throws -> Data {
        let publicKey = Crypto.generatePublicKey(data: privateKey, compressed: true)
        return publicKey;
    }
    
    /// Address data generated from public key in data format
    func addressDataFromPublicKey(publicKey: Data) -> Data {
        return Crypto.hashSHA3_256(publicKey.dropFirst()).suffix(20)
    }
    
    override func generateAddress() {
        let publicKey = Crypto.generatePublicKey(data: (self.pathPrivateKey?.raw)!, compressed: false)
        self.address = Address(data: addressDataFromPublicKey(publicKey: publicKey)).string
        self.wif = self.pathPrivateKey?.raw.toHexString()
    }
    
    override func createOwnWallet(created: Date, fnew: Bool) {
        do {
            try generateExternalKeyPair(at: 0)
        
            let privateKey = getPrivateKeyStr()
            
            self.privKey = try? EthereumPrivateKey(hexPrivateKey: privateKey)
        
            DDLogDebug("\nEthereum private key = \(String(describing: privateKey))")
            DDLogDebug("Ethereum address1 = \(String(describing: self.privKey?.address.hex(eip55: true)))")

        } catch {
            DDLogDebug(error as! String)
        }
    }
}
