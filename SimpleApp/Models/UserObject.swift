//
//  UserObject.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation
import RealmSwift

struct ResultsModel: Decodable {
    let results: [UserObject]
}

final class UserObject: Object, Decodable {
    @objc dynamic var gender: Gender.RawValue?
    @objc dynamic var location: LocationObject?
    @objc dynamic var email: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var dob: DobObject?
    @objc dynamic var picture: PictureObject?
    @objc dynamic var uuid: String = ""
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var nameTitle: String = ""
    override static func primaryKey() -> String? {
        return "uuid"
    }
    override static func indexedProperties() -> [String] {
        return ["uuid"]
    }
    
    private enum CodingKeys: String, CodingKey {
        case gender, name, location, email, phone, dob, picture, uuid, login
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        gender = try container.decode(String.self, forKey: .gender)
        location = try container.decode(LocationObject.self, forKey: .location)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decode(String.self, forKey: .phone)
        dob = try container.decode(DobObject.self, forKey: .dob)
        picture = try container.decode(PictureObject.self, forKey: .picture)
        let loginContainer = try container.decode(LoginModel.self, forKey: .login)
        uuid = loginContainer.uuid
        let userName = try container.decode(NameModel.self, forKey: .name)
        firstName = userName.first
        lastName = userName.last
        nameTitle = userName.title
    }
    override init() {
        super.init()
    }
    
    static func getAllUsers(onlyFavorite: Bool) -> Results<UserObject>? {
        let realm = try! Realm()
        if onlyFavorite {
            return realm.objects(UserObject.self).filter("isFavorite == %@", true)
        }
        return realm.objects(UserObject.self)
    }
    
    static func save(users: [UserObject]) {
        let realm = try! Realm()
        if realm.isInWriteTransaction == false {
            realm.beginWrite()
        }
        users.forEach { user in
            realm.add(user, update: .all)
        }
        try! realm.commitWrite()
    }
    
    static func toggleIsFavoriteForUser(with id: String) {
        let realm = try! Realm()
        let user = realm.objects(UserObject.self).filter("uuid == %@", id).first
        if realm.isInWriteTransaction == false {
            realm.beginWrite()
        }
        user?.isFavorite.toggle()
        try? realm.commitWrite()
    }
    static func getUser(by id: String) -> UserObject {
        let realm = try! Realm()
        guard let user = realm.objects(UserObject.self).filter("uuid == %@", id).first else {
            fatalError("user is nil")
        }
        return user
    }
    func toggleIsFavorite() {
        let realm = try! Realm()
        if realm.isInWriteTransaction == false {
            realm.beginWrite()
        }
        isFavorite.toggle()
        try? realm.commitWrite()
    }
}

struct LoginModel: Decodable {
    var uuid: String = ""
    var username: String = ""
}
struct NameModel: Decodable {
    var first: String = ""
    var last: String = ""
    var title: String = ""
}
final class LocationObject: Object, Decodable {
    @objc dynamic var city: String = ""
    @objc dynamic var state: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var street: StreetObject?
    @objc dynamic var coordinates: CoordinatesObject?
}
final class StreetObject: Object, Decodable {
    @objc dynamic var number: Int = 0
    @objc dynamic var name: String = ""
}
final class CoordinatesObject: Object, Decodable {
    @objc dynamic var latitude: String = ""
    @objc dynamic var longitude: String = ""
}
final class DobObject: Object, Decodable {
    @objc dynamic var age: Int = 0
}
final class PictureObject: Object, Decodable {
    @objc dynamic var large: String = ""
    @objc dynamic var medium: String = ""
    @objc dynamic var thumbnail: String = ""
}
