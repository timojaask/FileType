import XCTest
@testable import FileType

fileprivate let packageRootPath = URL(fileURLWithPath: #file)
  .pathComponents
  .prefix(while: { $0 != "Tests" })
  .joined(separator: "/")
  .dropFirst()

fileprivate let fixturesPath = packageRootPath + "/Tests/Fixtures"

final class FileTypeTests: XCTestCase {
  func testFileType(_ fixtureName: String, type: FileTypeExtension) {
    let absolutePath = "\(fixturesPath)/\(fixtureName)"
    let url = URL(fileURLWithPath: absolutePath, isDirectory: false)
    
    guard let data = try? Data(contentsOf: url) else {
      print("Fixture not found: \(absolutePath). Look for a specific test function.")
      return
    }
        
    let fileType = getFileType(from: data)
    XCTAssertEqual(fileType?.type, type)
  }
  
  func testAll() {
    for fileType in FileType.all {
      testFileType("fixture.\(fileType.ext)", type: fileType.type)
    }
  }
  
  func testTAR() {
    testFileType("fixture.tar.Z", type: .Z)
    testFileType("fixture.tar.gz", type: .gz)
    testFileType("fixture.tar.lz", type: .lz)
    testFileType("fixture.tar.xz", type: .xz)
  }
    
  func testMPC() {
    testFileType("fixture-sv7.mpc", type: .mpc)
    testFileType("fixture-sv8.mpc", type: .mpc)
  }
    
  func testTIFF() {
    testFileType("fixture-big-endian.tif", type: .tif)
  }
  
  func testAPE() {
    testFileType("fixture-monkeysaudio.ape", type: .ape)
  }
  
  func testMIE() {
    testFileType("fixture-big-endian.mie", type: .mie)
    testFileType("fixture-little-endian.mie", type: .mie)
  }
  
  func testNEF() {
    testFileType("fixture2.nef", type: .nef)
    testFileType("fixture3.nef", type: .nef)
    testFileType("fixture4.nef", type: .nef)
  }
  
  func testDNG() {
    testFileType("fixture2.dng", type: .dng)
  }
  
  func testARW() {
    testFileType("fixture2.arw", type: .arw)
    testFileType("fixture3.arw", type: .arw)
    testFileType("fixture4.arw", type: .arw)
    testFileType("fixture5.arw", type: .arw)
  }
  
  func testBytesCountForType() {
    XCTAssertEqual(getBytesCountForType(.ac3), 2)
    XCTAssertEqual(getBytesCountForType(.zip), 4)
    XCTAssertEqual(getBytesCountForType(.cab), 4)
  }
  
  func testBytesCountForTypes() {
    XCTAssertEqual(getBytesCountForTypes([.ac3, .zip, .cab]), 4)
  }
    
  static var allTests = [
    ("testAll", testAll),
    ("testTAR", testTAR),
    ("testMPC", testMPC),
    ("testTIFF", testTIFF),
    ("testAPE", testAPE),
    ("testMIE", testMIE),
    ("testNEF", testNEF),
    ("testDNG", testDNG),
    ("testARW", testARW),
    
    ("testBytesCountForType", testBytesCountForType),
    ("testBytesCountForTypes", testBytesCountForTypes),
  ]
}