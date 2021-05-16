<p align="center"><img src="https://laravel.com/assets/img/components/logo-laravel.svg"></p>

<p align="center">
<a href="https://travis-ci.org/laravel/framework"><img src="https://travis-ci.org/laravel/framework.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://poser.pugx.org/laravel/framework/d/total.svg" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://poser.pugx.org/laravel/framework/v/stable.svg" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://poser.pugx.org/laravel/framework/license.svg" alt="License"></a>
</p>

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

- [Simple, fast routing engine](https://laravel.com/docs/routing).
- [Powerful dependency injection container](https://laravel.com/docs/container).
- Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage.
- Expressive, intuitive [database ORM](https://laravel.com/docs/eloquent).
- Database agnostic [schema migrations](https://laravel.com/docs/migrations).
- [Robust background job processing](https://laravel.com/docs/queues).
- [Real-time event broadcasting](https://laravel.com/docs/broadcasting).

Laravel is accessible, powerful, and provides tools required for large, robust applications.

## Learning Laravel

Laravel has the most extensive and thorough [documentation](https://laravel.com/docs) and video tutorial library of all modern web application frameworks, making it a breeze to get started with the framework.

If you don't feel like reading, [Laracasts](https://laracasts.com) can help. Laracasts contains over 1100 video tutorials on a range of topics including Laravel, modern PHP, unit testing, and JavaScript. Boost you and your team's skills by digging into our comprehensive video library.

## Laravel Sponsors

We would like to extend our thanks to the following sponsors for funding Laravel development. If you are interested in becoming a sponsor, please visit the Laravel [Patreon page](https://patreon.com/taylorotwell).

- **[Vehikl](https://vehikl.com/)**
- **[Tighten Co.](https://tighten.co)**
- **[Kirschbaum Development Group](https://kirschbaumdevelopment.com)**
- **[64 Robots](https://64robots.com)**
- **[Cubet Techno Labs](https://cubettech.com)**
- **[Cyber-Duck](https://cyber-duck.co.uk)**
- **[British Software Development](https://www.britishsoftware.co)**
- **[Webdock, Fast VPS Hosting](https://www.webdock.io/en)**
- **[DevSquad](https://devsquad.com)**
- [UserInsights](https://userinsights.com)
- [Fragrantica](https://www.fragrantica.com)
- [SOFTonSOFA](https://softonsofa.com/)
- [User10](https://user10.com)
- [Soumettre.fr](https://soumettre.fr/)
- [CodeBrisk](https://codebrisk.com)
- [1Forge](https://1forge.com)
- [TECPRESSO](https://tecpresso.co.jp/)
- [Runtime Converter](http://runtimeconverter.com/)
- [WebL'Agence](https://weblagence.com/)
- [Invoice Ninja](https://www.invoiceninja.com)
- [iMi digital](https://www.imi-digital.de/)
- [Earthlink](https://www.earthlink.ro/)
- [Steadfast Collective](https://steadfastcollective.com/)
- [We Are The Robots Inc.](https://watr.mx/)
- [Understand.io](https://www.understand.io/)
- [Abdel Elrafa](https://abdelelrafa.com)

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-source software licensed under the [MIT license](https://opensource.org/licenses/MIT).
## requirements
    Composer version 1.10.8
    php version  7.2 
    laravel version 5.8.11 

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

##4.    Paste or move project files to `/var/www/html/safe_you` folder (all files)
###  use your git repo or copy/paste src codes

##5. 	install composer required packages for laravel (`laravel/composer.json`)
    cd /var/www/html/safe_you/laravel/ 
    composer install
    cp .env.example .env
## overwrite configs
    nano .env

#### fill all config settings with your credentials:`db connection`, `mail account` and other configs
    APP_ENV=production
##### use debugger : `false` to `true`
    APP_DEBUG=false
#### put your domain name : `http://safe_you.org`
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
#### if you want to add country you should add database connection

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
### image upload paths
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
      DEVICE_APP_API_KEY_POST_IOS=a87659a7-9595-4b25-9c31-8610f4a817eb
      DEVICE_APP_API_KEY_POST_ANDROID=b24c3ded-e6f7-43ba-b5b0-cc9c86d58b59
      
      DEVICE_APP_API_KEY_GET_IOS=022701ef-9a74-4678-a440-df71c45460d8
      DEVICE_APP_API_KEY_GET_ANDROID=02ea2275-bf7b-47a4-bcb7-754f1197def0

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
####  you can overwrite in  `safe_you\laravel\database\seeds\DatabaseSeeder.php` file and execute this command
   	php artisan migrate --seed

##6. Install frontend requirements packages (package.json)

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
safe_you/
   |-.env.example
   |-app
   | |-Helpers
   | | |-FileLib.php
   | | |-NeutrinoAPI.php
   | | |-PseudoCrypt.php
   | | |-SendSMS.php
   | |-Http
   | | |-Controllers (all controllers)
   | | | |-AdminController.php
   | | | |-APIs
   | | | | |-Applications
   | | | | | |-APIController.php
   | | | | |-Auth
   | | | | | |-ForgotPassword.php
   | | | | | |-IssueTokenTrait.php
   | | | | | |-LoginController.php
   | | | | | |-RegisterController.php
   | | | | | |-ResetPassword.php
   | | | | | |-SocialAuthController.php
   | | | |-ConsultantController.php
   | | | |-ConsultantRequestController.php
   | | | |-ContactUsController.php
   | | | |-ContentsController.php
   | | | |-Controller.php
   | | | |-CountryController.php
   | | | |-EmergencyServiceCategoryController.php
   | | | |-EmergencyServiceController.php
   | | | |-ForumDiscussionsController.php
   | | | |-ForumsController.php
   | | | |-HelpMessageController.php
   | | | |-ImageController.php
   | | | |-LanguagesController.php
   | | | |-ProfessionConsultantServiceCategoryController.php
   | | | |-SettingController.php
   | | | |-SmsController.php
   | | | |-UserController.php
   | | | |-UserRecordsController.php
   | | |-Kernel.php
   | | |-Middleware
   | | | |-Authenticate.php
   | | | |-CheckAccess.php
   | | | |-CheckForMaintenanceMode.php
   | | | |-CORS.php
   | | | |-EncryptCookies.php
   | | | |-RedirectIfAuthenticated.php
   | | | |-SetLocale.php
   | | | |-TrimStrings.php
   | | | |-TrustProxies.php
   | | | |-VerifyCsrfToken.php
   | | |-Validator
   | | | |-CustomValidationRule.php
   | |-Mail
   | | |-ContactUsEmail.php
   | | |-ForgotPasswor.php
   | | |-ResponseLetter.php
   | | |-SendEmail.php
   | |-Models (models)
   | | |-ConsultantRequest.php
   | | |-ContactUs.php
   | | |-Contents.php
   | | |-ContentTranslations.php
   | | |-Country.php
   | | |-CountryTranslation.php
   | | |-EmergencyService.php
   | | |-EmergencyServiceCategory.php
   | | |-EmergencyServiceCategoryTranslation.php
   | | |-EmergencyServiceTranslation.php
   | | |-ForumDiscussions.php
   | | |-Forums.php
   | | |-ForumTranslations.php
   | | |-HelpMessage.php
   | | |-HelpMessageTranslation.php
   | | |-Image.php
   | | |-Languages.php
   | | |-ProfessionConsultantServiceCategory.php
   | | |-ProfessionConsultantServiceCategoryTranslation.php
   | | |-Setting.php
   | | |-Sms.php
   | | |-SocialLink.php
   | | |-UserEmergencyContacts.php
   | | |-UserEmergencyServiceContacts.php
   | | |-UserRecords.php
   |-composer.json
   |-config
   |-database
   | |-factories
   | | |-ConsultantRequestFactory.php
        ...
   | |-migrations (migrations)
   | | |-2014_10_12_000000_create_functions.php
        ...
   | |-seeds (default data for insert db)
   | | |-ContentSeeder.php
   | | |-CountrySeeder.php
   | | |-DatabaseSeeder.php
   | | |-HelpMessageSeeder.php
   | | |-ImageSeeder.php
   | | |-LanguageSeeder.php
   | | |-SettingSeeder.php
   | | |-UserSeeder.php
   |-public
   |-resources
   | |-lang (languages and translations)
   | | |-az
   | | | |-auth.php
   | | | |-messages.php
   | | | |-pagination.php
   | | | |-passwords.php
   | | | |-validation.php
   | | |-en
   | | | |-auth.php
   | | | |-messages.php
   | | | |-pagination.php
   | | | |-passwords.php
   | | | |-validation.php
   | | |-hy
   | | | |-auth.php
   | | | |-messages.php
   | | | |-pagination.php
   | | | |-passwords.php
   | | | |-validation.php
   | | |-ka
   | | | |-auth.php
   | | | |-messages.php
   | | | |-pagination.php
   | | | |-passwords.php
   | | | |-validation.php
   | |-views
   | | |-Email
   | | | |-client.blade.php
   | | | |-contact_us.blade.php
   | | | |-forgot_password.blade.php
   | | | |-help.blade.php
   | | | |-response_letter.blade.php
   | | |-errors
   | | | |-403.blade.php
   | | | |-404.blade.php
   | | | |-500.blade.php
   | | |-welcome.blade.php
   |-routes
   | |-api.php
   | |-channels.php
   | |-console.php
   | |-web.php
       ...
```
##### if you want to use other language you should create and add in resources/lang folder your language translations
## Copyright and license

Copyright 2021 Fambox. 
