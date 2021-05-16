What is used:
======
- ***MySql (^5.7)*** - For saving forums, comments, users, etc...
- ***Redis*** - For saving notifications.
- ***Node.JS (Socket.IO ^2)*** - For Android/IOS/WEB etc...
- ***Node.JS (Express ^4.13.4)*** - For backend.

Configuration:
======
```json5
{
  "APP.NAME": "SafeYOU_V4",                                         // Your app name
  "APP.HOST": "127.0.0.1",                                          // App host
  "APP.PORT": 3000,                                                 // App port
  "APP.DEBUG": true,                                                // App debugging
  "SOCKET_HOST_FOR_TEST": "https://127.0.0.1:3000",                 // Page for testing socket functionality
  "APP_FIREBASE.DB_URL": "https://<your_app>.firebaseio.com",       // Firebase Service link for notifications
  "DB.HOST": "127.0.0.1",                                           // MySql - host
  "DB.PORT": 3306,                                                  // MySql - port
  "DB.DATABASE": "arm_safe_you_dev",                                // MySql - database name 
  "DB.USERNAME": "safeyou",                                         // MySql - database username
  "DB.PASSWORD": "qwertyQWERTY123!@#",                              // MySql - database password
  "REDIS.HOST": "127.0.0.1",                                        // Redis - host
  "REDIS.PORT": 6379,                                               // Redis - port
  "REDIS.EXPIRE": 864000,                                           // Redis - notification retention period
  "APP.API_KEY": "C2359A8C1DA7DFA54437C40D57A44BCC",                // access key to express routes for requests
  "APP.ROUTES_AUTH": [
    {
      "username": "your_username",                                  // 
      "password": "your_password"                                   // 
    }
  ],
}
```

How to run:
======
```
~ cd ./forumBack
~ npm install
~ node server.js -config=./configs/configuration.json -ssl_key=/etc/ssl/private/file_name.key -ssl_crt=/etc/ssl/file_name.crt
```

For backend 
======
```
// For update profession in all sockets.
http://127.0.0.1:3000/api/profession/:profession_id/refresh/:secret_key

// For update categories in all sockets.
http://127.0.0.1:3000/api/category/:category_id/refresh/:secret_key

// For update socket profile info.
http://127.0.0.1:3000/api/profile/:user_id/refresh/:secret_key

// For update socket profile info.
http://127.0.0.1:3000/api/profile/:user_id/refresh/:secret_key

// For send forum notification in all sockets.
http://127.0.0.1:3000/api/forum/:forum_id/:secret_key

// For update forums in all sockets.
http://127.0.0.1:3000/api/forum/:forum_id/refresh/:is_create/:secret_key
``` 
***

Using Events and Emitters 
======
## Connection parameters:
 - Required ti use parameter "**key**". The "**key**" is bearer token for connection authentication.
    example: 
```
ws://127.0.0.1:11080?key=eyJ0eXE5Zjk0MjZjZWYjJjMzI2MWYjk5ZDY0NjVkZDcxMzQwYjQ5In0... 
``` 
***
##    1) Get profile info:

- To send a request to receive your profile, you need to send emitter "**SafeYOU_V4##PROFILE_INFO**".
- To get your profile infos you need to add this "**SafeYOU_V4##PROFILE_INFO#RESULT**". 
```json5
// Result of response(JSON): 
{
    "error": null,
    "data": {
        "name": "Admin",
        "user_type": "Administrator",
        "user_id": 2,
        "image_path": "<IMAGE URL>",
        "location": null,
        "email": "administrator@gmail.com",
        "phone": "+00000000000",
        "birthday": "2021-04-26",
        "role": 1,
        "consultant_id": null,
        "user_type_id": 1
    }
}
```
***
##    2) Get forums list:
- To send a request to receive all forums, you need to send this emitter "**SafeYOU_V4##GET_ALL_FORUMS**" with parameters.
```json5
// Parameters(JSON): 
{
    "language_code": "en",    // required, String
    "forums_rows": 10,        // required, int
    "forums_page": 0,         // required, int
    "datetime": 1590060984,   // required, int
}
```
- To get all the forums you need to add this event "**SafeYOU_V4##GET_ALL_FORUMS#RESULT**". 
```json5
// Result of response(JSON):
{
    "error": null,
    "data": [
        {
            "id": 1,
            "NEW_MESSAGES_COUNT": 0,
            "title": "<TEXT...>",
            "sub_title": "<TEXT...>",
            "short_description": "<TEXT...>",
            "description": "<TEXT...>",
            "created_at": "2021-03-26T11:00:55.000Z",
            "code": "en",
            "image_path": "<IMAGE URL>",
            "comments_count": 0
        },
    ],
    "total_data_count": 8
}
```
***
##    3) Get forum by ID:
- To send a request to receive forum by forum_id, you need to send this emitter "**SafeYOU_V4##FORUM_MORE_INFO**" with parameters.
```json5
// Parameters(JSON): 
{
    "language_code": "en",   // required, String
    "forum_id": 1,           // required, int
    "comments_rows": 10,     // required, int
    "comments_page": 0       // required, int
}
```
- To get the forum you need to add this event "**SafeYOU_V4##FORUM_MORE_INFO#RESULT**". 
```json5
// Result of response(JSON): 
{
    "error": null,
    "data": {
        "id": 1,
        "title": "<TEXT...>",
        "sub_title": "<TEXT...>",
        "short_description": "<TEXT...>",
        "description": "<TEXT...>",
        "created_at": "2020-05-05T10:25:03.000Z",
        "code": "en",
        "image_path": "<IMAGE URL>",
        "comments_count": 356,
        "comments": [
            {
                "user_id": 11,
                "id": 1,
                "reply_id": null,
                "group_id": 1,
                "level": 0,
                "user_type_id": 5,
                "consultant_id": null,
                "service_id": null,
                "reply_count": null,
                "user_type": "VISITOR",
                "name": "<TEXT...>",
                "image_path": "<IMAGE URL>",
                "message": "<TEXT...>",
                "created_at": "2021-01-26T16:36:41.000Z",
                "my": false
            },
        ],
        "reply_list": [
            {
                "user_id": 1,
                "id": 1,
                "reply_id": 1,
                "group_id": 1,
                "level": 3,
                "user_type_id": 5,
                "consultant_id": null,
                "service_id": null,
                "reply_count": 6,
                "user_type": "VISITOR",
                "name": "<TEXT...>",
                "image_path": "<IMAGE URL>",
                "message": "<TEXT...>!",
                "created_at": "2021-01-18T13:16:44.000Z",
                "my": false
            },
        ]
    }
}
```
***
##    4) Add new comment:
- To send a request to add new comments, you need to send this emitter "**SafeYOU_V4##ADD_NEW_COMMENT**" with parameters.
```json5
// Parameters(JSON): 
{
    "language_code": "en",      // required, text,
    "forum_id": 3,              // required, int
    "reply_id": 3,              // not mandatory, int
    "reply_user_id": 3,         // not mandatory, int
    "level": 3,                 // required, int
    "group_id": 3,              // required, int
    "messages": "<Text....>",   // required, long text
}
```
- To get the new comments you need to add this event "**SafeYOU_V4##ADD_NEW_COMMENT#RESULT**". 
```json5
// Result of response(JSON): 
{
    "error": null,
    "data": {
        "id": 1,
        "group_id": 1,
        "level": 1,
        "consultant_id": 1,
        "user_type_id": 1,
        "user_id": 11,
        "user_type": "ngo",
        "name": "<FULL NAME>",
        "image_path": "<IMAGE URL>",
        "message": "<Text....>",
        "created_at": "Sep 14, 2019",
        "reply_id": 10,
        "my": true,
        "comments_count": 105
    }
}
```
***
##    5) Delete comment:
- To send a request to delete comment by id, you need to send this emitter "**SafeYOU_V4##DELETE_COMMENT**" with parameters.
```json5
// Parameters(JSON): 
{
    "group_id": 3,   // required, int
    "id": 3,         // required, int
}
```
- To get the deleted comments you need to add this event "**SafeYOU_V4##DELETE_COMMENT#RESULT**". 
```json5
// Result of response(JSON): 
[
    1,2,3,4 // messages id
]
```
***
##    6) Get total comments count:
- To send a request to get total comments count, you need to send this emitter "**SafeYOU_V4##GET_TOTAL_NEW_COMMENTS_COUNT**" with parameters.
```json5
// Parameters(JSON): 
{
    "datetime": 1590060984, // required, int
}
```
- To get the total comments count you need to add this event "**SafeYOU_V4##GET_TOTAL_NEW_COMMENTS_COUNT#RESULT**". 
```json5
// Result of response(JSON): 
{
    "error": null,
    "count": 52
}
```
***
##    7) Get new comments count:
- To send a request to get new comments count, you need to send this emitter "**SafeYOU_V4##GET_NEW_COMMENTS_COUNT**" with parameters.
```json5
// Parameters(JSON): 
{
    "datetime": 1590060984, // required, int
}
```
- To get the new comments count you need to add this event "**SafeYOU_V4##GET_NEW_COMMENTS_COUNT#RESULT**". 
            
```json5
// Result of response(JSON): 
{
    "error": null,
    "data": [
        {
            "forum_id": 1,
            "count": 193
        }
    ]
}
```
***
##    8) Get a new profession or category:
- To get the new profession you need to add this event "**SafeYOU_V4##NEW_PROFESSION#RESULT**".
- To get the new category you need to add this event "**SafeYOU_V4##NEW_CATEGORY#RESULT**".
```json5
// Result of response(JSON):
{
    "error": null,
    "data": [
        {
            "id": 1,
            "translation": "<Text...>",
            "language_id": 1,
            "code": "<Text...>",
            "title": "<Text...>",
        }
    ]
}
```
***
##    8) Get notifications:
- To send a request to get notifications, you need to send this emitter "**SafeYOU_V4##NOTIFICATION**".
```json5
// Parameters(JSON): 
{ }
```
- To send a request to read notification, you need to send this emitter "**SafeYOU_V4##READ_NOTIFICATION**" with parameters.
```json5
// Parameters(JSON): 
{
  "key": "user_1_2_300" // notification key is "user_${reply_user_id}_${user_id}_${comment.insertId}"
}
```
- To get the notifications you need to add this event "**SafeYOU_V4##NOTIFICATION#RESULT**".
```json5
// Result of response(JSON):
{
    "error": null,
    "data": [
        {
            "id": 1,
            "forum_id": 1,
            "reply_id": 2,
            "user_id": 3,
            "user_type": "ngo",
            "level": 1,
            "name": "<TEXT...>",
            "image_path": "<IMAGE_PATH>",
            "isReaded": 0,
            "key": "user_1_2_300",
            "created_at": "2021-01-18T13:16:44.000Z",
        }
    ]
}
```
***
