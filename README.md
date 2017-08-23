## Access

Access the project via [Disnumber.com](http://www.disnumber.com)!

## Project Description

Disnumber is a free service that provides a persistent, memorable english language phrase for any number you don't want to have to remember. Use it for phone numbers, IDs, serial numbers, or any other number you need to remember or exchange.

First look up the number, and then you can use the unique phrase whenever you want to let someone else use the number or check it yourself.

Disnumber doesn't keep your personal information other than any numbers you provide, and won't ever contact you or share any number you enter.

Because Disnumber can include dialing characters (like +, #, and \*) it's particularly useful for international phone numbers. When searching by phrase, the corresponding number can be called by tapping the number if you're using Disnumber on a smartphone.

Disnumber is a project by Javed de Costa. If you have any issues or feedback, get in touch [through my github](github.com/javeddc).

## API Documentation

Disnumber has a free API – it's easy to use. 

It's accessible at [http://www.disnumber.com/api_request](http://www.disnumber.com/api_request). It takes one parameter, "search", which you can give a search string. This can be a number or a phrase – the API will detect what type and return the appropriate response. Numbers can include +, * and # characters. Phrases must have no special characters, and must be separated by a space. 

The result format is a JSON string. 

Sucessful number lookup result: 
`{"result":"honeycomb waterfall","error_message":"","result_type":"phrase"}`

Sucessful phrase lookup result: 
`{"result":"+61417418089","error_message":"","result_type":"number"}`

Error example: 
`{"result":"","error_message":"No number was found for this phrase. Please check your phrase and try again!","result_type":"error"}`

## Implementation Notes

Disnumber is a Sinatra app, backed by a PostgreSQL database. It was written for Ruby version 2.4.1, and deployed on Heroku. Disnumber uses PG and ActiveRecord for the database and Bcrypt for password handling.

The app depends on having access to a PostgreSQL database named 'disnumber' and having a table structure that follows that outlined in `/schema.txt`.

Once you have set up the database, you should be able to run the `main.rb` in Ruby and see the app in action on your own machine. Or, more likely, you can just head to the [live version](http://www.disnumber.com).

There is Javascript input validation in the front end, and also further server side validation.

Users can flag phrases they think are inappropriate, or just want to change. An admin-accessible control panel was also implemented, allowing admin accounts to view these flags and change requests, and resolve them within the browser.

Copyright 2017. Feel free to incorporate Disnumber and the Disnumber API into your projects – but please always have a link visible to www.disnumber.com. 
