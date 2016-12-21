import PackageDescription

var package = Package(
    name: "MongoKitten",
    targets: [
        Target(name: "MongoKitten")
        ],
    dependencies: [
        // For MongoDB Documents
        .Package(url: "https://github.com/OpenKitten/BSON.git", majorVersion: 4),

        // Authentication
        .Package(url: "https://github.com/OpenKitten/CryptoKitten.git", Version(0,0,2)),
        
        // Provides sockets
        .Package(url: "https://github.com/vapor/socks.git", majorVersion: 1),

        // SSL
//        .Package(url: "https://github.com/vapor/tls.git", majorVersion: 1),
        .Package(url: "https://github.com/IBM-Swift/BlueSSLService.git", majorVersion: 0, minor: 12),

        // Logging
        .Package(url: "https://github.com/OpenKitten/LogKitten.git", majorVersion: 0, minor: 3),
    ]
)

let lib = Product(name: "MongoKitten", type: .Library(.Dynamic), modules: "MongoKitten")
