//
//  Movie.swift
//  Hexad Rating
//
//  Created by Anubhav Chandra on 6/2/20.
//  Copyright © 2020 Anubhav Chandra. All rights reserved.
//

import Foundation

class Movie{
    private var _title:String!
    private var _genre:[String]!
    private var _rating:Int!
    private var _image: String!
    
    init() {
        
    }
    
    public var title:String{
        get{
           return _title
        }
        set{
           _title = newValue
        }
    }
    public var genre:[String]{
        get{
           return _genre
        }
        set{
           _genre = newValue
        }
    }
    public var rating:Int{
        get{
           return _rating
        }
        set{
           _rating = newValue
        }
    }
    public var image:String{
        get{
           return _image
        }
        set{
           _image = newValue
        }
    }
}
