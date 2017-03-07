# API DOCUMENTATION

Here i will describe all the methods and it respectives returns
____

## GET SURVIVORS

Endpoint:&nbsp;&nbsp;/survivors

Method: &nbsp;&nbsp; GET

Description: It will return a list of all survivors in a json that have all the informations related to a survivor
>Returns: age, created_at, gender, id, last_x, last_y, name, report_infected, update_at

>status code: 200

## GET ITEMS

Endpoint:&nbsp;&nbsp;/items

Method: &nbsp;&nbsp; GET

Description: It will return a list of all items in a json that have all the informations related to a item
>Returns: created_at, id, name, points, update_at

>status code: 200

##  GET SURVIVOR BY ID

Endpoint:&nbsp;&nbsp;/survivors/:id

Method: &nbsp;&nbsp; GET

Description: It will return a json with all the information related to a survivor, unless the survivor is infected, in that case it will return a message with the error
>Returns: age, created_at, gender, id, last_x, last_y, name, report_infected, update_at

>status code: 200

## GET INVENTORY

Endpoint:&nbsp;&nbsp;/survivors/:id/inventory

Method: &nbsp;&nbsp; GET

Description: It will return the list of the items in the inventory of a survivor.
>Params: for each item, name, points, quant

>status code: 204

## SURVIVORS REPORT


Endpoint:&nbsp;&nbsp;/infected_rel

Method: &nbsp;&nbsp; GET

Description: It will return a json with a report about the amount of the survivors, that include, the amount of infected ones, total ones and other things.
>Returns: infected, percent_infected, percent_non_infected, total

>status code: 200

## RESOURCES REPORT


Endpoint:&nbsp;&nbsp;/resources_rel

Method: &nbsp;&nbsp; GET

Description: It will return a json with a report about the resources, the average of each resource by survivor.
>Returns: the name of the resource with the respective average

>status code: 200

## POINTS LOST REPORT


Endpoint:&nbsp;&nbsp;/infected/:id

Method: &nbsp;&nbsp; GET

Description: It will return a json with the total of the points that is lost with a infected survivor.
>Returns: survivor_id, survivor_name,total_lost_points

>status code: 200

## POST SURVIVOR

Endpoint:&nbsp;&nbsp;/survivors

Method: &nbsp;&nbsp; POST

Description: It will insert a new survivor in the database, at the same time will insert the items in the invetory of the new survivor, that is the only way to post items to the invetory
>Params: name, age, last_x, last_y, gender, and a collection of items

>status code: 201

## POST ITEM

Endpoint:&nbsp;&nbsp;/items

Method: &nbsp;&nbsp; POST

Description: It will insert a new item in the database.
>Params: name, points

>status code: 201

## UPDATE LAST LOCATION

Endpoint:&nbsp;&nbsp;/survivors/update_location

Method: &nbsp;&nbsp; PUT

Description: It will update the last location of a chosen survivor
>Params: id, last_x, last_y

>status code: 204

## REPORT INFECTION

Endpoint:&nbsp;&nbsp;/survivors/report_infection

Method: &nbsp;&nbsp; PUT

Description: It will report a infection by increment in one unit the report_infected field of a survivor, and when it reachs a 3 he will be consider as infected.
>Params: id

>status code: 204

## TRADE ITEM

Endpoint:&nbsp;&nbsp;/survivors/trade

Method: &nbsp;&nbsp; PUT

Description: This method going trade the items between two survivors, it just had to respect some constrains like, the items exists in the survivors inventory, the survivor could not be infected, and the sum of points of the trade items have to be equivalent.
>Params: for each item, s_id, it_id, quant

>status code: 204

# NOTES

* In all cases that the survivor do not exist, will return a message that indicates the non existence.

* Every method have test to see if the survivor is infected, in the case that is positive, will be received a forbidden code (403) and a message.

* There are automated tests in the spec folder to run use the command below.
>bundle exec rspec
