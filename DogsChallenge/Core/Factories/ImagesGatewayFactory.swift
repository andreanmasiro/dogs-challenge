import Foundation

protocol ImagesGatewayFactory {
    func make(endpoint: URL) -> ImagesGateway
}

class DefaultImagesGatewayFactory: ImagesGatewayFactory {
    func make(endpoint: URL) -> ImagesGateway {
        return SingletonModule.shared.makeImagesGateway(endpoint: endpoint)
    }
}
