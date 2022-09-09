import os
import requests
from datetime import datetime
from dotenv import load_dotenv

def get_icon(id: str):
    match id:
        # clear sky
        case "01d":
            return "%{F#ebcb8b}%{F-}"
        case "01n":
            return "%{F#ebcb8b}%{F-}"
        # few clouds
        case "02d":
            return "%{F#88c0d0}%{F-}"
        case "02n":
            return "%{F#88c0d0}%{F-}"
        # scattered clouds
        case "03d":
            return "%{F#88c0d0}%{F-}"
        case "03n":
            return "%{F#88c0d0}%{F-}"
        # broke clouds
        case "04d":
            return "%{F#88c0d0}%{F-}"
        case "04n":
            return "%{F#88c0d0}%{F-}"
        # shower rain
        case "09d":
            return "%{F#5e81ac}%{F-}"
        case "09n":
            return "%{F#5e81ac}%{F-}"
        # rain
        case "10d":
            return "%{F#5e81ac}%{F-}"
        case "10n":
            return "%{F#5e81ac}%{F-}"
        # thunderstorm
        case "11d":
            return "%{F#5e81ac}%{F-}"
        case "11n":
            return "%{F#5e81ac}%{F-}"
        # snow
        case "13d":
            return "%{F#5e81ac}%{F-}"
        case "13n":
            return "%{F#5e81ac}%{F-}"
        # mist
        case "50d":
            return "%{F#5e81ac}%{F-}"
        case "50n":
            return "%{F#5e81ac}%{F-}"

def wind_deg_to_dir(deg):
    if (0 < deg and deg <= 22.5):
        return "%{F#88c0d0}%{F-}"
    elif (22.5 < deg and deg <= 67.5):
        return "%{F#88c0d0}%{F-}"
    elif (67.5 < deg and deg <= 112.5):
        return "%{F#88c0d0}%{F-}"
    elif (112.5 < deg and deg <= 157.5):
        return "%{F#88c0d0}%{F-}"
    elif (157.5 < deg and deg <= 202.5):
        return "%{F#88c0d0}%{F-}"
    elif (202.5 < deg and deg <= 247.5):
        return "%{F#88c0d0}%{F-}"
    elif (247.5 < deg and deg <= 292.5):
        return "%{F#88c0d0}%{F-}"
    elif (292.5 < deg and deg <= 337.5):
        return "%{F#88c0d0}%{F-}"
    elif (337.5 < deg and deg <= 360):
        return "%{F#88c0d0}%{F-}"

load_dotenv()

city_name = "Leiden"
api_key = os.getenv('API_KEY')
api_url_current = f"https://api.openweathermap.org/data/2.5/weather?q={city_name}&appid={api_key}&units=metric"
api_url_forecast = f"https://api.openweathermap.org/data/2.5/forecast?q={city_name}&appid={api_key}&units=metric&cnt=2"

responds_current = requests.get(api_url_current)
responds_forecast = requests.get(api_url_forecast)

if (responds_current.status_code != 200) :
    print("Weather => ", responds_current.status_code)
elif (responds_forecast.status_code != 200):
    print("Forecast => ", responds_forecast.status_code)
else:
    # CURRENT DATA #
    content_current = responds_current.json()
    content_forecast = responds_forecast.json()['list'][1]

    main_current = content_current['main']
    temp_current = round(main_current['temp'])

    wind_current = content_current['wind']
    wind_speed_current = round(wind_current['speed'])
    wind_deg_current = wind_current['deg']
    wind_dir_current = wind_deg_to_dir(wind_deg_current)

    wind_icon = "%{F#88c0d0}%{F-}"
    wind_current = f"{wind_speed_current} m/s {wind_dir_current}"

    sys = content_current['sys']
    sunrise_icon = "%{F#d08770}%{F-}"
    sunrise = datetime.fromtimestamp(int(sys['sunrise'])).strftime("%H:%M")
    sunset_icon = "%{F#d08770}%{F-}"
    sunset = datetime.fromtimestamp(int(sys['sunset'])).strftime("%H:%M")
    
    _ = f"{sunrise_icon} {sunrise} {sunset_icon} {sunset}"
    
    # FORECAST DATA #

    weather_current = content_current['weather'][0]
    id_current = weather_current['icon']
    icon_current = get_icon(id_current)
    
    main_forecast = content_forecast['main']
    temp_forecast = round(main_forecast['temp'])

    wind_forecast = content_forecast['wind']
    wind_speed_forecast = round(wind_forecast['speed'])
    wind_deg_forecast = wind_forecast['deg']
    wind_dir_forecast = wind_deg_to_dir(wind_deg_forecast)

    wind_icon = "%{F#88c0d0}%{F-}"
    wind_forecast = f"{wind_speed_forecast} m/s {wind_dir_forecast}"

    weather_forecast = content_forecast['weather'][0]
    id_forecast = weather_forecast['icon']
    icon_forecast = get_icon(id_forecast)

    output = f"{icon_current} {temp_current}°C {wind_icon} {wind_current} | {icon_forecast} {temp_forecast}°C {wind_icon} {wind_forecast}"

    print(output)
    print(responds_forecast.json())