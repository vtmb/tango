import Foundation
import Kitura
import KituraNet
import KituraStencil
import HeliumLogger
import LoggerAPI
import MySQL

// username and password are placeholders.
// Needs MySQL Database with tango database and table milonga.
func connectToDatabase() throws -> (Database, Connection) {
   let mysql = try Database(host: "localhost", user: "user", password: "password", database: "tango")
   let connection = try mysql.makeConnection()
   return (mysql, connection)
}

func getMilongasAsJSON() -> [Milonga] {
    let (db, connection) = try! connectToDatabase()
    let query = "select * from milongas"
    let milongas = try! db.execute(query, [], connection)

    var milongaModels = [Milonga]()
    for milonga in milongas {
        let location = milonga["location"]?.string ?? ""
        let cost = milonga["cost"]?.int ?? 0
        let city = milonga["city"]?.string ?? ""
        let time = milonga["time"]?.string ?? ""
        let weekday = milonga["weekday"]?.string ?? ""
        let roto = milonga["roto"]?.string ?? ""
        let contact = milonga["contact"]?.string ?? ""
        let annotation = milonga["annotation"]?.string ?? ""
        milongaModels.append(Milonga(weekday: weekday, roto: roto, location: location, city: city, time: time, annotation: annotation, contact: contact, cost: cost))
    }
    return milongaModels
}

HeliumLogger.use()
let router = Router()
router.setDefault(templateEngine: StencilTemplateEngine())

router.get("milongalist") { request, response, next in 
    defer { next() }
    let models = getMilongasAsJSON() 
    try response.render("milongalist", context: ["milongas" : models])
}

router.get("milongalist/:city") { request, response, next in
    defer { next() }
    guard let filterCity = request.parameters["city"] else { return }
    let cityName = filterCity.lowercased().capitalizingFirstLetter()
    let models = getMilongasAsJSON()
    let filteredModels = models.filter { $0.city == cityName }
    try response.render("milongalist", context: ["milongas" : filteredModels])
}

router.get("/api/milongas/:city") { request, response, next in
    defer { next() }
    print("searching in city!")
    guard let city = request.parameters["city"] else { return }
    let cityName = city.lowercased().capitalizingFirstLetter()
    print("searching in city \(cityName)")
    let query = "select * from milongas where city = '\(city)';"
    print("query: \(query)")
    let (db, connection) = try! connectToDatabase()
    let milongas = try db.execute(query, [], connection)

    var parsedMilongas = [[String: Any]]()
    for milonga in milongas {
        var milongaDict = [String: Any]()
        milongaDict["location"] = milonga["location"]?.string
	milongaDict["cost"] = milonga["cost"]?.int
	milongaDict["time"] = milonga["time"]?.string
	milongaDict["weekday"] = milonga["weekday"]?.string
	milongaDict["roto"] = milonga["roto"]?.string
        parsedMilongas.append(milongaDict)
    }

    var result = [String: Any]()
    result["status"] = "ok"
    result["milongas"] = parsedMilongas

    response.headers["Content-Type"] = "application/json; charset=utf-8"

    do {
        print("response")
        try response.status(.OK).send(json: result).end()
    } catch {
        print("catch block")
        Log.warning("failed")
    }
}

router.get("/api/milongas") { request, response, next in
    defer { next() }
    print("did route to milongas")
    let query = "select * from milongas;"
    let (db, connection) = try connectToDatabase()
    let milongas = try db.execute(query, [], connection)

    var parsedMilongas = [[String: Any]]()
    for milonga in milongas {
	var milongaDict = [String: Any]()
	milongaDict["location"] = milonga["location"]?.string
	milongaDict["cost"] = milonga["cost"]?.int
        milongaDict["time"] = milonga["time"]?.string
        milongaDict["weekday"] = milonga["weekday"]?.string
        milongaDict["roto"] = milonga["roto"]?.string
        parsedMilongas.append(milongaDict)
	parsedMilongas.append(milongaDict)
    }

    response.headers["Content-Type"] = "application/json; charset=utf-8"

    var result = [String: Any]()
    result["status"] = "ok"
    result["milongas"] = parsedMilongas
    do {
	print("response")
	try response.status(.OK).send(json: result).end()
    } catch {
	print("catch block")
	Log.warning("failed")
    }
}


Kitura.addHTTPServer(onPort: 8090, with: router)
Kitura.run()
