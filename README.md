# Safeyou
### Safeyou
[![SafeYouPlayStore](https://play-lh.googleusercontent.com/AnIs0TtPU4CpZ9u7wn7WrGTFUcdtOekBZ2DZes5cB0Ie5fcTx-mq25x99vfIasgZZKg=s360-rw)](https://play.google.com/store/apps/details?id=fambox.pro)

# Offered By
Impact Innovations Institute LLC
# Website
## [Safeyou official website](https://safeyou.space/)
# Safe YOU mobile App description
Safe YOU is a multifunctional safety app for mobile device users and a web platform for different stakeholders (NGOs, Governmental organizations, individual specialists), who provide support services to women to prevent and protect them in case violence. Available currently in Armenia and Georgia the App permits the users to send free alert SMS with their geolocation to up-to 7 prechosen contacts, including the Police.

#### How to start using the App

The first step is to choose the country and the preferred language available in the given country, then to proceed to the registration using mobile phone number.
To register users should fill-in the necessary information: name, surname, birth date- this information will not be available to other users, they will only see the nickname, created by the user during registration.
After registration, a **tutorial** page is shown to the users explaining each function of the App.

#### App features
**Choosing Emergency Contacts:** In the **Support section** users can select up to three personal contacts, three support contacts from the service provider organizations listed the Network section of the App, as well as enable the Police contact function.

**Help Function:** By pressing and holding the green button for three seconds the App will simultaneously send a free alert SMS with the user’s geo-location to up to 7 previously chosen contacts.

**Audio Recording:** Pressing and holding the green button for three seconds also enables the audio recording function for one minute. The audio record is kept in the recordings’ library and can be sent to service providers and the police or deleted at any time.

**Network:** In the **Network section** of the app the users can find relevant information, such as contact details, hotlines, mapped location, website and social media links on nearby women's rights NGOs, governmental organizations, and individual specialists, supporting women in different ways. 

**Forums:** In the **Forums section** of the App users can engage in anonymous peer-to-peer discussions in topicals chat rooms and get consultation from women support organizations, as well as verified consultants such as lawyers, psychologists, doctors, and other counselors who are identifiable by a special badge. 

**Security functions:** To enable safe usage of the App for users, who want to hide the App from others, Dual PIN and Camouflage functions are developed.

**User Profile:** In the **Profile section** of the App the users can add/edit a profile picture, edit their data filled-in during the registration, as well as send consultancy request. 

**Consultancy Request:** The App also provides possibility to upgrade the ordinary user profile status to a verified consultant, by undergoing a procedure of submitting consultancy request in the Profile section of the App.

**Notifications:** The App provides in App notifications for forum discussions.

--------------------------------------------------------------------------------------------------------------------------------

#Android

# Used programming language
+ Java
+ Kotlin

# Instalation
Clone this repository and import into Android Studio
```bash
git clone 
```
# Build Config
```bash
compileSdkVersion 30
    buildToolsVersion '29.0.3'
    defaultConfig {
        applicationId "fambox.pro"
        minSdkVersion 21
        targetSdkVersion 30
        versionCode 16
        versionName "2.2.3"
    }...
```
# Java Version
```bash
compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }...
```
# Kotlin Version
```bash
buildscript {
    ext.kotlin_version = '1.4.20'
    repositories {
      ........
    }
}
```
# Connecting Socket 
+ localhost:3000/forum/readme

# Build variants
Use the Android Studio Build Variants button to choose between **production** and **staging** flavors combined with debug and release build types

# Used technologies
+ REST API
+ Retrofit2 
+ RxJava
+ Socket IO
+ Google MAP, Location

--------------------------------------------------------------------------------------------------------------------------------

#iOS
* Introduction:
	Native iOS application written in Objective C used Foundation Framework and CocoaTouch Frameworks.
	Also used third party libraries and frameworks which dependencies are configured with CocoaPods.
	Application Deployment targets are iOS versions above 11.0

 * Requirements:
	MacOS versions above 10.14
	Xcode versions above 11.0
	CocoaPods installed on Mac

 * Installation:
	Download Project sources from repository
	Do pod install (or pod update) in project root folder
	Open <project_name>.xcworkspace file with Xcode
	Select iOS device or simulator and run the application

 * Configuration:
	Setup developer and/or distribution Certificates from Apple Developer Account

 * Troubleshooting:
	Make sure that API URLs (defined in Constants.h file) and SocketIO URLs (Defined in Settings.m depending user selected Country) are available
 
 --------------------------------------------------------------------------------------------------------------------------------
 
#Chat
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

#Administration Panel
## Installation

Use the package manager [pip](https://pip.pypa.io/en/stable/) to install foobar.

Download and install node js for your operating system 	https://nodejs.org/en/	

Install angular cli (open terminal and enter)
```bash
#project angular version is (7.2.10),  project angular-cli version is (7.3.6)
 npm install -g @angular/cli	
#Download and install git for your operating system		https://git-scm.com/downloads	
#Clone the repository (open terminal and enter)
git clone https://github.com/Violence-android.git	
#Go into angular directory (enter in terminal)
cd adminUi	
#Install app's dependencies (enter in terminal)						
npm install 
'''

## Usage

```bash
#Go into angular directory
cd adminUi
#Serve with hot reload at localhost:4200
ng serve
#Build for production with minification
npm start
#Go into Node JS directory
cd forumBack
#Start node server
npm start

```



--------------------------------------------------------------------------------------------------------------------------------
    
# Backend

# Used programming languages
### Composer version 1.10.8
### php version  7.2 
### laravel version 5.8.11 

# Install Project

## Install backend requirements (soft, extensions and configurations)
1. install apache2 php server

   `apt install apache2` (https://www.digitalocean.com/community/tutorials/linux-apache-mysql-php-lamp-ubuntu-18-04-ru)

   `apt install php libapache2-mod-php php-mysql`
   `a2enmod rewrite`
   (https://www.digitalocean.com/community/tutorials/how-to-rewrite-urls-with-mod_rewrite-for-apache-on-ubuntu-16-04)
###      install php extensions
	apt-get install php7.2-curl php7.2-gd php7.2-json php7.2-mbstring php7.2-intl php7.2-mysql php7.2-xml php7.2-zip
## Create virtual host or change default
	nano /etc/apache2/sites-available/000-default.conf
	
	<VirtualHost *:80>
 	ServerAdmin safeyoudmin@safeyou.org
	ServerName safeyou.org
	ServerAlias www.safeyou.org
    	DocumentRoot /var/www/html/safe_you/laravel/public
    	<Directory /var/www/html/safe_you/laravel>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    	</Directory>
	</VirtualHost>
	
	nano /etc/hosts
	127.0.0.1   safeyou.org
	a2dissite 000-default.conf
	a2ensite 000-default.conf
	service apache2 reload
	service apache2 restart
## 2.	Install Mysql server
    apt install mysql-server
    mysql_secure_installation (configurate and set password and create user)
## 	continue mysql installations by setting password and etc

##	login to mysql server as root user (check if mysql service is running)
    service mysql status (return mysql service status - running/stopped)
    service mysql start(run mysql service)
    mysql -uroot -p and enter your mysql password	 
##	Create new user using the following command
	CREATE USER 'db_some_username'@'%' IDENTIFIED BY 'db_some_password';
	GRANT ALL PRIVILEGES ON *.* TO 'db_some_username'@'%' identified by 'db_some_password' with grant option;
	FLUSH PRIVILEGES;
##	Create new database using the following command
   	CREATE DATABASE `db_some_database_name` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    exit;

##3. 	Install composer
   	apt install php-cli
   	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
   	php composer-setup.php --install-dir=/usr/local/bin --filename=composer

##4. 	install nodejs
   	apt install nodejs  

##5. 	install npm
   	apt install npm

##6. 	install Angular cli global
   	npm install -g @angular/cli

###7.    Paste or move project files to `/var/www/html/safe_you` folder (all files)
####  use your git repo or copy/paste src codes

##8. 	install composer required packages for laravel (`laravel/composer.json`)
    cd /var/www/html/safe_you/laravel/ 
    composer install
    cp .env.example .env
## overwrite configs
    nano .env

#### fill all config settings with your credentials:`db connection`, `mail account` and other configs
    APP_ENV=production
##### use debugger : `false` to `true`
    APP_DEBUG=false
##### put your domain name : `http://safe_you.org`
    APP_URL=http://safe_you.org
###
    TOKENS_EXPIRE_IN_DAYS=60
    REFRESH_TOKENS_EXPIRE_IN_DAYS=60
    USERS_LOGIN_HISTORY_LIMIT=3
### overwrite app socket configs
      APP_SOCKET_URL_{country_1_code 3 letter in upper case}=your_host_for country_1
      APP_SOCKET_URL_{country_1_code 3 letter in upper case}=your_host_for country_2
      APP_SOCKET_SECRET_KEY=your_secret_key

### DB Connection 1 for first country (with country code 3 string)
    DB_CONNECTION=mysql_{country_code}
    DB_HOST=127.0.0.1
    DB_PORT=3306
    DB_DATABASE={country_code}_database_1_name
    DB_USERNAME=user_name
    DB_PASSWORD=user_password
### DB Connection 2 for second country (with country code 3 string)
    DB_CONNECTION=mysql_{country_code}
    DB_HOST_SECOND=127.0.0.1
    DB_PORT_SECOND=3306
    DB_DATABASE_SECOND={country_code}_database_1_name
    DB_USERNAME_SECOND=user_name
    DB_PASSWORD_SECOND=user_password
## if you want to add country you should add database connection

### remember life time
    REMEMBER_ME_EXP_TIME="+6 months"

### Mail Configs
      MAIL_DRIVER=smtp
      MAIL_HOST=your_mail_host
      MAIL_PORT=your_mail_port
      MAIL_USERNAME=your_mail_user_name
      MAIL_PASSWORD=your_mail_user_password
      MAIL_ENCRYPTION=your_mail_encryption 
      MAIL_URL=your_mail_url
      MAIL_FROM_ADDRESS=your_mail_from_address
      MAIL_FROM_NAME=your_mail_from_name
      MAIL_USERS=["your_mail_mail_users_email"]
      REPLY_NAME="your_mail_reply_name"
      REPLY_ADDRESS=your_mail_reply_address
      SUPPORT_EMAIL_ADDRESS=your_mail_support_email_address
## #image upload paths
      UPLOAD_ADMIN_PROFILE_IMAGE=/upload/images/users/profiles/admins/
      UPLOAD_USER_PROFILE_IMAGE=/upload/images/users/profiles/users/
      UPLOAD_LANGUAGE_FLAG_IMAGE=/upload/images/languages/flags/
      UPLOAD_COUNTRY_FLAG_IMAGE=/upload/images/countries/flags/
      UPLOAD_CONSULTANT_SERVICE_PROFILE_IMAGE=/upload/images/users/profiles/consultant/
      UPLOAD_EMERGENCY_SERVICE_PROFILE_IMAGE=/upload/images/users/profiles/emergency/
      UPLOAD_ICON_IMAGE=/upload/images/icons/
      UPLOAD_SOCIAL_MEDIA_IMAGE=/upload/images/social_media/
      UPLOAD_FORUM_IMAGE=/upload/images/forums/
      UPLOAD_AUDIO_FILE=/upload/records/
### upload images size
       SIZE_IMAGE=102400
       SIZE_IMAGE_BYTE=1048576
### overwrite DEVICE_APP_API_KEYS
      DEVICE_APP_API_KEY_POST_IOS=a876zxa7-9595-4b25-9c31-8610f4a817eb
      DEVICE_APP_API_KEY_POST_ANDROID=baa4c6ded-e6f7-43ba-b5b0-cc9c86d58b59
      
      DEVICE_APP_API_KEY_GET_IOS=a876zxa7-9595-4b25-9c31-8610f4a817eb
      DEVICE_APP_API_KEY_GET_ANDROID=baa4c6ded-e6f7-43ba-b5b0-cc9c86d58b59

###	send sms service 1 configs
      SMS_HOST=your_sms_host
      SMS_LOGIN=your_sms_login
      SMS_PASSWORD=your_sms_password
      SMS_SERVICE_NUMBER=your_sms_service_number
###	send sms service 2 configs with Country(Country name must be upper case ex. GEORGIA)
      {country}_SMS_SERVICE_ID=your_sms_id
      {country}_SMS_CLIENT_ID=your_sms_client_id
      {country}_SMS_PASSWORD=your_sms_password
      {country}_SMS_USERNAME=your_sms_user_name

### 	in this folder enter this command (generate app key)
    php artisan key:generate
### 	every time to change laravel configurations (in `.env` file) you have to execute this command to clear old cached configs
   	php artisan clear

### if would you like insert data admin users this command(recommended)
   	php artisan migrate --seed
###  you can overwrite in  `safe_you\laravel\database\seeds\DatabaseSeeder.php` file and execute this command
   	php artisan migrate --seed

##9. Install frontend requirements packages (package.json)

## Prerequisites
Before you begin, make sure your development environment includes `Node.js®` and an `npm` package manager.

#### Node.js
Angular requires `Node.js` version 8.x or 10.x.

- To check your version, run `node -v` in a terminal/console window.
- To get `Node.js`, go to [nodejs.org](https://nodejs.org/).
#### Angular CLI
##### Install the Angular CLI globally using a terminal/console window.
      npm install -g @angular/cli

      cd /var/www/html/safe_you/angular
      npm install
##10. Install chat requirements packages in node folder (package.json)
      cd /var/www/html/safe_you/node
      npm install

##11.     build project
   	npm start

##12. 	change permission and group for safe_you folder
   	chown -R www-data /var/www/html/safe_you
   	chgrp -R www-data /var/www/html/safe_you
### use new host and restart apache2 server
   	a2ensite 000-default.conf
   	service apache2 reload
   	service apache2 restart
## Finish
####use {your host name}/administrator/{country_code -3 letter}/login or localhost url to access the app

`login : administrator@safeyou.org`
`password : admin12345!`

---------------------------------------------------------------------------------------------------


## What's included

Within the download you'll find the following directories and files, logically grouping common assets and providing both compiled and minified variations. You'll see something like this:

```
SafeYou/
  angular
    ├── e2e/
    ├── src/
    │   ├── app/
    │   ├── assets/
    │   ├── environments/
    │   ├── scss/
    │   ├── index.html
    │   └── ...
    ├── angular.json
    ├── ...
    ├── package.json
    └── ...
  laravel
    ├── app/
    ├── bootstrap/
    ├── config/
    ├── database/
    ├── public/
    ├── ...
    ├── env.example
    ├── composer.json
    └── ...
```
