import Foundation

public class Milonga: Codable {
    var weekday: String
    var roto: String
    var location: String
    var city: String
    var time: String
    var annotation: String
    var contact: String
    var cost: Int

    public init(weekday: String, roto: String, location: String, city: String, time: String, annotation: String, contact: String, cost: Int) {
        self.weekday = weekday
	self.roto = roto
	self.location = location
	self.city = city
	self.time = time
	self.annotation = annotation
	self.contact = contact
	self.cost = cost
    }
}
