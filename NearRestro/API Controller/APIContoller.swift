

import UIKit

protocol APIContollerDelegate {
    
    
    func getResponsse(response:Data)
}
class APIContoller: NSObject  {
    
    
    class func sendRequest(url: String ,delegate:APIContollerDelegate?){
       
        var apiResponse = ""
        let headers = [
            "User-Agent": "PostmanRuntime/7.15.0",
            "Accept": "*/*",
            "Cache-Control": "no-cache",
            "Postman-Token": "d7dfbc38-e711-4393-a293-dc2f4967b5b4,d5adee89-6c1a-4235-a16a-c5117bc000d2",
            "Host": "api.foursquare.com",
            "cookie": "bbhive=E4ZCIBPGVH12B4LSKE2IXQVOEMYGDE%3A%3A1630215376",
            "accept-encoding": "gzip, deflate",
            "Connection": "keep-alive",
            "cache-control": "no-cache"
        ]
        
    let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 30.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
      
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard error == nil else {
                DispatchQueue.main.async {
                    
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    
                }
                
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                delegate?.getResponsse(response: data)
            }
            
        })
        
        dataTask.resume()
}

}
