//
//  Common.swift
//  Ostmodern
//
//  Created by Administrator on 30/03/2016.
//  Copyright © 2016 mahesh lad. All rights reserved.
//

import Foundation

let root_url = "http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000"
let default_image = "http://feature-code-test.skylark-cms.qa.aws.ostmodern.co.uk:8000/static/images/dummy/dummy-film.jpg"

struct Sets  {
    var id : String
    var link : String
    var data : NSData
    var title : String
    var episode : [String]
  
    init(id: String, link: String, data:NSData, title: String, episode : [String]) {
        self.id = id
        self.link = link
        self.data = data
        self.title = title
        self.episode = episode
        }

}




