show dbs;
use test;
show collections;

//1. Display all documents in collection.
db.restaurants.find();

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//2. Display the number of documents in collection.
db.restaurants.countDocuments();

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//3. Retrieve 1st 5 documents.
db.restaurants.find().limit(5);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//4. Retrieve restaurants in the Brooklyn borough.
db.restaurants.find({"borough": "Brooklyn"});
/*
var myRestaurants= db.restaurants.find({"borough": "Brooklyn"})
myRestaurants
*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//5. Retrieve restaurants whose cuisine is American.
db.restaurants.find({"cuisine": "American "});

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//6. Retrieve restaurants whose borough is Manhattan and cuisine is hamburgers.
db.restaurants.find({"cuisine": "Hamburgers"}, {"borough": "Manhattan"});
//db.restaurants.find({"cuisine": "Hamburgers"}, {"borough": "Manhattan"}), {"name": 1, "restaurant_id": 1}; //only name and rest_id + pk
//db.restaurants.find({"cuisine": "Hamburgers"}, {"borough": "Manhattan"}), {"_id": 0, "name": 1, "restaurant_id": 1}; //only name and rest_id w/o pk

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//7. Display the number of restaurants whose borough is Manhattan and cuisine is hamburgers.
db.restaurants.find({"cuisine": "Hamburgers"}, {"borough": "Manhattan"}).count();

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//8. Query zipcode field in embedded address document. Retrieve restaurants in the 10075 zip code area.
db.restaurants.find({"address.zipcode": "10075"});

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//9. Retrieve restaurants whose cuisine is chicken and zip code is 10024.
db.restaurants.find({"cuisine": "Chicken","address.zipcode": "10024"});// implicit AND
//db.restaurants.find({$and: [{"cuisine": "Chicken"}, {"address.zipcode": "10024"}]});// explicit AND

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//10. Retrieve restaurants whose cuisine is chicken or whose zip code is 10024.
db.restaurants.find({$or: [{"cuisine": "Chicken"}, {"address.zipcode": "10024"}]});

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//11. Retrieve restaurants whose borough is Queens, cuisine is Jewish/kosher, sort by descending order of zipcode.
db.restaurants.find({"borough": "Queens", "cuisine": "Jewish/Kosher"}).sort({"address.zipcode": -1});

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//12. Retrieve restaurants with a grade A.
db.restaurants.find({"grades.grade": "A"});

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//13. Retrieve restaurants with a grade A, displaying only collection id, restaurant name, and grade.
db.restaurants.find({"grades.grade": "A"}, {"name": 1, "grades.grade": 1});

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//14. Retrieve restaurants with a grade A, displaying only restaurant name, and grade (no collection id):
db.restaurants.find({"grades.grade": "A"}, {"_id": 0, "name": 1, "grades.grade": 1});

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//15. Retrieve restaurants with a grade A, sort by cuisine ascending, and zip code descending.
db.restaurants.find({"grades.grade": "A"}).sort({"cuisine": 1, "address.zip": -1});

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//16. Retrieve restaurants with a score higher than 80.
db.restaurants.find({"grades.score":{$gt: 80}});

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*17. Insert a record with the following data:
    street = 7th Avenue
    zip code = 10024
    building = 1000
    coord = -58.9557413, 31.7720266
    borough = Brooklyn
    cuisine = BBQ
    date = 2015-11-05T00:00:00Z
    grade" : C
    score = 15
    name = Big Tex
    restaurant_id = 61704627*/
db.restaurants.insertOne(
    {
        "address" :{
            "building" : "1000",
            "coord" : [-58.9557413, 31.7720266],
            "street" : "7th Avenue",
            "zipcode" : "10024",
        },
        "borough" : "Brooklyn",
        "cuisine" : "BBQ",
        "grades" :[
            {
            "date" : ISODate("2015-11-05T00:00:00Z"),
            "grade" : "C",
            "score" : 15
            }
        ],
        "name" : "Big Tex",
        "restaurant_id" : "61704627"
    }
);

// verify insert
db.restaurants.find().sort({_id : -1}).limit(1).pretty();

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*18. Update the following record:
    Change the first White Castle restaurant document's cuisine to "Steak and Sea Food," and update the lastModified field with the current date.*/
//find last one
db.restaurants.find({"name" : "White Castle"}).sort({"name": 1});
//update record
db.restaurants.update(
    {"_id" : ObjectId("662427c724a4a86b979b2075")},
    {$set : {"cuisine" : "Steak and Sea Food"}, $currentDate: {"lastModified" : true}}
);

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*19. Delete the following records:
    Delete all White Castle restaurants*/
db.restaurants.find({"name" : "White Castle"}).count();
db.restaurants.remove({"name" : "White Castle"});
db.restaurants.find({"name" : "White Castle"}).count();
