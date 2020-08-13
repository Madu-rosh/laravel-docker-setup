# larvel-docker-setup

Appreciate the effort and help me: <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=V7CYQD2WJQBCQ&source=url"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif"></a><style>.bmc-button img{height: 34px !important;width: 35px !important;margin-bottom: 1px !important;box-shadow: none !important;border: none !important;vertical-align: middle !important;}.bmc-button{padding: 7px 15px 7px 10px !important;line-height: 35px !important;height:51px !important;text-decoration: none !important;display:inline-flex !important;color:#ffffff !important;background-color:#5F7FFF !important;border-radius: 8px !important;border: 1px solid transparent !important;font-size: 24px !important;letter-spacing:0.6px !important;box-shadow: 0px 1px 2px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;margin: 0 auto !important;font-family:'Cookie', cursive !important;-webkit-box-sizing: border-box !important;box-sizing: border-box !important;}.bmc-button:hover, .bmc-button:active, .bmc-button:focus {-webkit-box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;text-decoration: none !important;box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;opacity: 0.85 !important;color:#ffffff !important;}</style><link href="https://fonts.googleapis.com/css?family=Cookie" rel="stylesheet"><a class="bmc-button" target="_blank" href="https://www.buymeacoffee.com/yTYPz7b"><img src="https://cdn.buymeacoffee.com/buttons/bmc-new-btn-logo.svg" alt="Buy me a coffee"><span style="margin-left:5px;font-size:24px !important;">Buy me a coffee</span></a>

### Project Details ###

System Info - the versions i tried
* Laravel 6.2
* Mariadb (MySQL) - 10.2.26
* PHP - php:7.3.12-apache-stretch


this should work with latest versions why not check and give it a try and add an update! 

### Project Setup ###
Add these files into your laravel project and make sure you follow steps below.if all went well your docker container should be up and running.please update here in case you got an issue or any suggession to improve this.

##### Important #####
1.  **here in docker-compose.yml file ports are assigned(as 80 and 3309) to avoid conflicts with local apache and mysql server if any installed.** 
2.  **if not you can use port 80:80 in port setting for laravel-app and port 3306:3306 in mariadb**
3.  **please make sure .env is updated before you build docker and custom.ini,laravel-worker.conf files available -- these are already in repo**

##### Steps #####
1.  run `cp .env.example .env` and make sure db settings are ok. especially DB_HOST.
    example settings as follow.      
    `DB_CONNECTION=mysql
      DB_HOST=mariadb
      DB_PORT=3306
      DB_DATABASE=my_db
      DB_USERNAME=admin
      DB_PASSWORD=admin`
    
2.  then need to build the docker
    1.  `docker-compose build && docker-compose up -d && docker-compose logs -f`
    2.  this will take some time to get build.
        if all went correct the containers will be up and running.
