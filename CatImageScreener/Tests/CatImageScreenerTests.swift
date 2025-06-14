import CatAPIClient
import CatImageLoader
import CatImageScreener
import ScaryCatScreeningKit
import XCTest

final class CatImageScreenerTests: XCTestCase {
    var screener: CatImageScreener!

    override func setUp() {
        super.setUp()
        screener = CatImageScreener()
    }

    override func tearDown() {
        screener = nil
        super.tearDown()
    }

    /// スクリーナーが正しく初期化され、ScaryCatScreenerインスタンスを返すことを確認
    func testInitialScreener() async throws {
        let firstScreener = try await screener.getScreener()
        XCTAssertNotNil(firstScreener)

        let secondScreener = try await screener.getScreener()
        XCTAssertNotNil(secondScreener)
        XCTAssertTrue(firstScreener === secondScreener)
    }

    /// MockCatImageLoaderを使用して画像処理が正常に実行できることを確認
    func testProcessImageWithMockLoader() async throws {
        let mockLoader = MockCatImageLoader()
        let mockAPIClient = MockCatAPIClient()

        let testModels = try await mockAPIClient.fetchImageURLs(totalCount: 2, batchSize: 2)
        let loadedImages = try await mockLoader.loadImageData(from: testModels)
        let results = try await screener.screenImages(imageDataWithModels: loadedImages)

        XCTAssertNotNil(results)
        XCTAssertTrue(results.count <= loadedImages.count)
    }
}
