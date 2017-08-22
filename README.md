## Access

Access the project via [Disnumber.com](http://www.disnumber.com)!

## Project Description

Disnumber is a free service that provides a persistent, memorable english language phrase for any number you don't want to have to remember. Use it for phone numbers, IDs, serial numbers, or any other number you need to remember or exchange.

First look up the number, and then you can use the unique phrase whenever you want to let someone else use the number or check it yourself.

Disnumber doesn't keep your personal information other than any numbers you provide, and won't ever contact you or share any number you enter.

Because Disnumber can include dialing characters (like +, #, and \*) it's particularly useful for international phone numbers. When searching by phrase, the corresponding number can be called by tapping the number if you're using Disnumber on a smartphone.

Disnumber is a project by Javed de Costa. If you have any issues or feedback, get in touch [through my github](github.com/javeddc).

## Implementation Notes

Disnumber is a Sinatra app, backed by a PostgreSQL database. It was written for Ruby version 2.4.1, and deployed on Heroku. Disnumber uses PG and ActiveRecord for the database and Bcrypt for password handling.

The app depends on having access to a PostgreSQL database named 'disnumber' and having a table structure that follows that outlined in `/schema.txt`.

Once you have set up the database, you should be able to run the `main.rb` in Ruby and see the app in action on your own machine. Or, more likely, you can just head to the [live version](http://www.disnumber.com).

There is Javascript input validation in the front end, and also further server side validation.

Users can flag phrases they think are inappropriate, or just want to change. An admin-accessible control panel was also implemented, allowing admin accounts to view these flags and change requests, and resolve them within the browser.
