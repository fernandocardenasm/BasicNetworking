//
//  KeychainWrapperTests.swift
//  BasicNetworkingTests
//
//  Created by Fernando Cardenas on 23.07.19.
//

import Foundation
@testable import BasicNetworking

class KeychainWrapperTests: XCTestCase {
    var sut: KeychainWrapper!

    override func setUp() {
        super.setUp()

        sut = KeychainWrapper(serviceName: "KeychainWrapperTests")
        // Makes sure that for the first test, the keychain is empty.
        _ = sut.clear()
    }

    override func tearDown() {
        // Makes sure that after each the test, the keychain is empty.
        _ = sut.clear()
        sut = nil

        super.tearDown()
    }

    /* The UnitTests cover mainly cases that do not depend on the methods SecItemAdd, SecItemUpdate and SecItemDelete. When those methods fail, they make the functions set(), removeObject() and clear() to return false. I decided against creating a Mock that allows me to set the value true / false for each specific case because I wanted to guarantee that the "happy paths" work using those real methods, in order to avoid having working unit tests, but a buggy real class.
     */

    func test_allKeychainItems_set_retrieveString_removeObject() {
        // A happy path of the methods: allKeychainItems(), set(value, forKey), retrieveString(forKey) and removeObject(forKey)
        // are tested in this unit test.
        let key = "key"
        // The value should be encoded as data using UTF-8. It can represent all valid Unicode code points,
        // therefore a very random string must still work.
        let value = "ƒ∂@€q®€ Very Random String ∑€®¥ç√å€®¶“¡€®¶¢"
        // The value for the key does not exist yet.
        XCTAssertNil(sut.retrieveString(forKey: key))
        // The keychainItems list is empty
        XCTAssertEqual(sut.allKeychainItems().count, 0)

        // Saves value for key
        guard sut.set(value, forKey: key) else {
            XCTFail("The value for the given key could not be saved .")
            return
        }
        XCTAssertEqual(sut.retrieveString(forKey: key), value)

        // It should overwrite the value when the key is the same
        let overwrittenValue = "anotherValue"
        guard sut.set(overwrittenValue, forKey: key) else {
            XCTFail("The value for the given key could not be overwritten .")
            return
        }
        XCTAssertEqual(sut.retrieveString(forKey: key), overwrittenValue)

        // Create a new value for a new key
        let newValue = "anotherValue"
        let newKey = "newKey"
        guard sut.set(newValue, forKey: newKey) else {
            XCTFail("The new Value for the given key could not be saved .")
            return
        }
        XCTAssertEqual(sut.retrieveString(forKey: newKey), newValue)
        // Makes sure that the items added so far are in the keychainItems.
        XCTAssertEqual(sut.allKeychainItems()[key], overwrittenValue)
        XCTAssertEqual(sut.allKeychainItems()[newKey], newValue)
        XCTAssertEqual(sut.allKeychainItems().count, 2)

        // Removes an object for the given key
        guard sut.removeObject(forKey: key) else {
            XCTFail("The value for the given key could be deleted.")
            return
        }
        XCTAssertNil(sut.retrieveString(forKey: key))
        // Makes sure that only the object with the given key was deleted and not others.
        XCTAssertEqual(sut.retrieveString(forKey: newKey), newValue)
        XCTAssertEqual(sut.allKeychainItems().count, 1)
    }

    func test_removeObject_unexistentKey__false() {
        XCTAssertEqual(sut.allKeychainItems().count, 0)
        // In this case we can make the test return false because a unexistent key is tried to be deleted.
        XCTAssertFalse(sut.removeObject(forKey: "key"))
    }

    func test_clear_emptyKeychain__true() {
        XCTAssertEqual(sut.allKeychainItems().count, 0)
        XCTAssertTrue(sut.clear())
    }

    func test_clear_keychainWithElements__true() {
        XCTAssertEqual(sut.allKeychainItems().count, 0)

        guard sut.set("value", forKey: "key") else {
            XCTFail("The value for the given key could not be saved .")
            return
        }
        guard sut.set("anotherValue", forKey: "anotherKey") else {
            XCTFail("The value for the given key could not be saved .")
            return
        }
        XCTAssertEqual(sut.allKeychainItems().count, 2)
        XCTAssertTrue(sut.clear())
        XCTAssertEqual(sut.allKeychainItems().count, 0)
    }

    func test_methods_anotherServiceName() {
        // This Test validates that an instance of KeychainWrapper with a different service name
        // executes its methods (allKeychainItems, retrieveString, set, removeObject, clear) in its own service
        // without affecting the other, regardless whether they use the same keys.
        let key = "key"
        let value = "value"
        let keychainWrapper = KeychainWrapper(serviceName: "AnotherServiceName")
        // Makes sure the Keychain for keychainWrapper starts empty.
        _ = keychainWrapper.clear()

        // Both Keychains start with empty items
        XCTAssertEqual(sut.allKeychainItems().count, 0)
        XCTAssertEqual(keychainWrapper.allKeychainItems().count, 0)

        // A Key-value pair is added only to the sut.
        XCTAssertTrue(sut.set(value, forKey: key))
        XCTAssertEqual(sut.allKeychainItems().count, 1)
        XCTAssertEqual(keychainWrapper.allKeychainItems().count, 0)

        // A Key-value pair is added only to the second keychainWrapper
        XCTAssertTrue(keychainWrapper.set(value, forKey: key))
        XCTAssertEqual(sut.allKeychainItems().count, 1)
        XCTAssertEqual(keychainWrapper.allKeychainItems().count, 1)

        // A Key-value pair is removed only the to the sut.
        XCTAssertTrue(sut.removeObject(forKey: key))
        XCTAssertEqual(sut.allKeychainItems().count, 0)
        XCTAssertEqual(keychainWrapper.allKeychainItems().count, 1)

        // Adds again a key-value pair for the sut
        XCTAssertTrue(sut.set(value, forKey: key))
        XCTAssertEqual(sut.allKeychainItems().count, 1)
        XCTAssertEqual(keychainWrapper.allKeychainItems().count, 1)

        // Both Keychains have the same key-value pair.
        XCTAssertEqual(sut.retrieveString(forKey: key), keychainWrapper.retrieveString(forKey: key))

        // The clear() only removes the items in the sut.
        XCTAssertTrue(sut.clear())
        XCTAssertEqual(sut.allKeychainItems().count, 0)
        XCTAssertEqual(keychainWrapper.allKeychainItems().count, 1)
    }
}
