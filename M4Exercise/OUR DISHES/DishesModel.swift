import Foundation
import CoreData


@MainActor
class DishesModel: ObservableObject {
    
    @Published var menuItems = [MenuItem]()        
    
    func reload(_ coreDataContext:NSManagedObjectContext) {
        guard let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/littleLemonSimpleMenu.json") else {
                print("Invalid URL")
                return
            }
        let urlSession = URLSession.shared
        
       
        // Perform the network request
           urlSession.dataTask(with: url) { data, response, error in
               // Handle network errors
               if let error = error {
                   print("Network error: \(error.localizedDescription)")
                   return
               }

               // Ensure data is non-nil
               guard let data = data else {
                   print("No data received")
                   return
               }

               // Decode the JSON data
               do {
                   let fullMenu = try JSONDecoder().decode(JSONMenu.self, from: data)
                   let menuItems: [MenuItem] = fullMenu.menuItems

                   // Perform Core Data operations on the main queue
                   DispatchQueue.main.async {
                       // Populate Core Data
                       Dish.deleteAll(coreDataContext)
                       Dish.createDishesFrom(menuItems: menuItems, coreDataContext)
                   }
               } catch {
                   print("JSON decoding error: \(error.localizedDescription)")
               }
           }.resume()
           
       
        
    }
}



func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
}


extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func itemsTask(with url: URL, completionHandler: @escaping (JSONMenu?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

