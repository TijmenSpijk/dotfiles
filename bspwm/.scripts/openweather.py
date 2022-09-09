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
api_url = f"https://api.openweathermap.org/data/2.5/weather?q={city_name}&appid={api_key}&units=metric"

responds = requests.get(api_url)

if (responds.status_code != 200) :
    print(responds.status_code)
else:
    content = responds.json()

    main = content['main']
    temp = main['temp']

    wind = content['wind']
    wind_speed = wind['speed']
    wind_deg = wind['deg']
    wind_dir = wind_deg_to_dir(wind_deg)

    sys = content['sys']
    sunrise_icon = "%{F#d08770}%{F-}"
    sunrise = datetime.fromtimestamp(int(sys['sunrise'])).strftime("%H:%M")
    sunset_icon = "%{F#d08770}%{F-}"
    sunset = datetime.fromtimestamp(int(sys['sunset'])).strftime("%H:%M")
    
    weather = content['weather'][0]
    id = weather['icon']
    icon = get_icon(id)

    wind_icon = "%{F#5e81ac}%{F-}"
    wind = f"{wind_speed} m/s {wind_dir}"

    output = f"{icon} {temp}°C {wind_icon} {wind} {sunrise_icon} {sunrise} {sunset_icon} {sunset}"

    os.environ['WIND'] = wind

    print(output)

    print(content)