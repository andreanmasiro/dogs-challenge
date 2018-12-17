import Foundation

class SingletonModule {
    static let shared = SingletonModule()

    private var breedsGateways = [URL: CacheHttpGetGateway<Breeds>]()
    func makeBreedsGateway(endpoint: URL) -> BreedsGateway {
        return make(Breeds.self, endpoint: endpoint, storeIn: &self.breedsGateways)
    }

    private var imagesGateways = [URL: CacheHttpGetGateway<Links>]()
    func makeImagesGateway(endpoint: URL) -> ImagesGateway {
        return make(Links.self, endpoint: endpoint, storeIn: &self.imagesGateways)
    }

    private func make<T: Decodable>(_: T.Type,
                                    endpoint: URL,
                                    storeIn dictionary: inout [URL: CacheHttpGetGateway<T>]) -> CacheHttpGetGateway<T> {
        return dictionary[endpoint] ?? {
            let gateway = CacheHttpGetGateway<T>(endpoint: endpoint)
            dictionary[endpoint] = gateway
            return gateway
            }()
    }
}
