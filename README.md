
Strucure: 
I used MVVM with Colusre binging

modular architecture : 


<img width="619" alt="Screen Shot 2021-10-07 at 11 30 24 PM" src="https://user-images.githubusercontent.com/20203547/136465005-a260e739-d95f-47c9-9f56-8a0274aedd51.png">

Also I used openweathermap to get all information for current weather as it's easy to use and json is easy to parse: 

used First Api to get current weather by city,state,country Code ==> api.openweathermap.org/data/2.5/weather?q={city name},{state code},{country code}&appid={API key}

used second api get current weather by lat and lon ==> api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}

Note: the apis didn't return Chance of precipitation so i didn't show it

For Story number 6: 

1- I added button to get weather of current location.

2- I added small animation when reload data from api
