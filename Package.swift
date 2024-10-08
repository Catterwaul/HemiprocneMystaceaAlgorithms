// swift-tools-version: 6.0

import Foundation // for String.capitalized
import PackageDescription

let shortenedName = "HMAlgorithms"

_ = Package(
  name: "HemiprocneMystaceaAlgorithms",
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [.library(name: shortenedName, targets: [shortenedName])],
  dependencies: dependencies.map(\.package),
  targets: [
    .target(
      name: shortenedName,
      dependencies: dependencies.dropFirst().map(\.product)
    ),
    .testTarget(
      name: shortenedName + ".Tests",
      dependencies: [.init(stringLiteral: shortenedName)]
    )
  ]
)

// MARK: - Dependency

nonisolated var dependencies: [Dependency]  {
  [ .swift(repositoryName: "docc-plugin"),
    .apple(repositoryName: "algorithms"),
    .apple(repositoryName: "collections"),
    .catterwaul(name: "Cast"),
    .catterwaul(name: "Thrappture"),
    .catterwaul(name: "Tuplé", repositoryName: "Tuplay")
  ]
}

struct Dependency {
  let package: Package.Dependency
  let product: Target.Dependency
}

extension Dependency {
  static func apple(repositoryName: String) -> Self {
    .swift(organization: "apple", repositoryName: repositoryName)
  }

  static func swift(organization: String = "swiftlang", repositoryName: String) -> Self {
    .init(
      organization: organization,
      name: repositoryName.split(separator: "-").map(\.capitalized).joined(),
      repositoryName: "swift-\(repositoryName)"
    )
  }

  static func catterwaul(name: String, repositoryName: String? = nil, branch: String? = nil) -> Self {
    .init(
      organization: "Catterwaul",
      name: name,
      repositoryName: repositoryName ?? name,
      branch: branch
    )
  }

  private init(organization: String, name: String, repositoryName: String, branch: String? = nil) {
    self.init(
      package: .package(
        url: "https://github.com/\(organization)/\(repositoryName)",
        branch: branch ?? "main"
      ),
      product: .product(name: name, package: repositoryName)
    )
  }
}
