//
//  CWID: 888632924
//  Created by Hung Cun on 10/15/20.
//
//  HW Assignment 1

import Kitura
import Cocoa

let router = Router()

router.all("/ClaimService/add", middleware: BodyParser())

router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to visit the service. ")
    next()
}

router.get("ClaimService/getAll"){
    request, response, next in
    let cList = ClaimDao().getAll()
    let jsonData : Data = try JSONEncoder().encode(cList)
    let jsonStr = String(data: jsonData, encoding: .utf8)
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    response.send("getAll service response data : \(cList.description)")
    next()
}

router.post("ClaimService/add") {
    request, response, next in
    // JSON deserialization
    let body = request.body
    let jObj = body?.asJSON
    if let jDict = jObj as? [String:String] {
        if let title = jDict["title"],let date = jDict["date"] {
            let cObj = Claim(id:UUID().uuidString, t: title, d: date, s: 0)
            ClaimDao().addClaim(cObj: cObj)
        }
    }
    response.send("The Claim record was successfully inserted (via POST Method).")
    next()
}


Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()

