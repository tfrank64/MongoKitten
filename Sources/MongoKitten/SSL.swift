//import Socks
//import SocksCore
//import TLS

import SSLService
import Socket
import Foundation

/*extension TLS.Socket: MongoTCP {
    public static func open(address hostname: String, port: UInt16, options: ClientSettings) throws -> MongoTCP {
        let address = hostname.lowercased() == "localhost" ? InternetAddress.localhost(port: port) : InternetAddress.init(hostname: hostname, port: port)
        
        let internetSocket = try TCPInternetSocket(address: address)
        let config = try TLS.Config(mode: .client, certificates: options.sslSettings?.certificates ?? .openbsd, verifyHost: !(options.sslSettings?.invalidHostNameAllowed ?? false), verifyCertificates: !(options.sslSettings?.invalidCertificateAllowed ?? false))
        
        let socket = try TLS.Socket(config: config, socket: internetSocket)
        
        try socket.connect(servername: hostname)
        
        return socket
    }
    
    public func send(data binary: [UInt8]) throws {
        try self.send(binary)
    }
    
    public func receive() throws -> [UInt8] {
        return try self.receive(max: Int(UInt16.max))
    }

    public var isConnected: Bool {
        return !socket.closed
    }
}*/

extension Socket: MongoTCP {
    
    // close and isConnected in Socket.swift
    
    public static func open(address hostname: String, port: UInt16, options: ClientSettings) throws -> MongoTCP {
        
        let socket = try Socket.create() // tcp socket
        print("made socket: \(socket)")
        if let settings = options.sslSettings, settings.enabled, let myConfig = settings.configuration {
            socket.delegate = try SSLService(usingConfiguration: myConfig)
        }
        print("host: \(hostname) and port: \(port)")
        try socket.connect(to: hostname, port: Int32(port))
        return socket
    }
    
    public func receive() throws -> [UInt8] {

        var myData = Data()
        _ = try self.read(into: &myData)
        let bytes = myData.map { UInt8($0) }
        
        return bytes
    }
    
    public func send(data binary: [UInt8]) throws {
        try self.write(from: Data(bytes: binary))
    }
    
}
