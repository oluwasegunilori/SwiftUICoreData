import Foundation
import CoreData


extension Dish {
    
    static func createDishesFrom(menuItems:[MenuItem],
                                 _ context:NSManagedObjectContext) {
        for item in menuItems {
            let dish = Dish(context: context)
            dish.name = item.title
            dish.price = Float(item.price) ?? 0.0
        }
        save(context)
    }
    
}
