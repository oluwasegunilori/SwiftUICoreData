import Foundation

struct JSONMenu: Codable {
    var menuItems: [MenuItem]
    enum CodingKeys: String, CodingKey {
        case menuItems = "menu"
    }
}


struct MenuItem: Codable, Hashable, Identifiable {
    
    var id : Int
    var title: String
    var price: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case price = "price"
    }
}
