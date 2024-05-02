import requests
import boto3
import os
from flask import send_file
import os
import json
import datetime


def get_coordinates(name):
    """"the function return tuple of the latitude, longitude, country"""
    # get latitude, longitude and country
    coordinates = requests.get(f"https://geocoding-api.open-meteo.com/v1/search?name={name}").json()
    if "results" not in coordinates:
        raise KeyError("invalid insertion")
    country = coordinates["results"][0]["country"]
    latitude = coordinates["results"][0]["latitude"]
    longitude = coordinates["results"][0]["longitude"]
    city = coordinates["results"][0]["name"]
    # return tuple
    return latitude, longitude, country, city


def weather(name):
    lat_long = get_coordinates(name)
    data = requests.get(f'https://api.open-meteo.com/v1/forecast?latitude={lat_long[0]}&longitude={lat_long[1]}'
                        f'&daily=weather_code,temperature_2m_max,temperature_2m_min,relative_humidity_'
                        f'2m_mean&forecast_days=7&timezone=auto').json()
    results = {}
    # allocate the
    for i in range(0, 7):
        # insert to "date" the date
        date = data["daily"]["time"][i]
        # in dict "results" create dict for each date and insert the nim nax and humidity as keys and their values
        results[date] = {
            'max_temp': data["daily"]["temperature_2m_max"][i],
            'min_temp': data["daily"]["temperature_2m_min"][i],
            'humidity': data["daily"]["relative_humidity_2m_mean"][i]
        }
    # return tuple with  dict with dates and the details of those dates and the country
    return results, lat_long[2], lat_long[3]


def download_image():
    s3_client = boto3.client('s3')
    s3_client.download_file("htmlstaticpage", "Stormclouds.jpg", 'Stormclouds.jpg')
    return send_file('Stormclouds.jpg', as_attachment=True)


def upload_dynamoDB(dictionary, city):
    dynamodb = boto3.resource('dynamodb', region_name="il-central-1")
    table = dynamodb.Table('WeatherData')
    for item in dictionary:
        print (item)
        response = table.put_item(
        Item = {
            'curr_data' : str(item) + " " + city ,
            'DayTemp': str(dictionary[item]['max_temp']),
            'NightTemp': str(dictionary[item]['min_temp']),
            'Humidity': str(dictionary[item]['humidity'])
            }
        )
    return response


def upload_dynamoDB_telAviv():
    dynamodb = boto3.resource('dynamodb', region_name="il-central-1")
    table = dynamodb.Table('WeatherData')
    dictionary = weather("tel aviv")
    for item in dictionary[0]:
        print (item)
        response = table.put_item(
        Item = {
            'curr_data' : str(item) + " " + "tel aviv" ,
            'DayTemp': str(dictionary[0][item]['max_temp']),
            'NightTemp': str(dictionary[0][item]['min_temp']),
            'Humidity': str(dictionary[0][item]['humidity'])
            }
        )
    return response


# Function to save search queries data to a JSON file
def save_to_json(data):
    current_date = datetime.datetime.now().strftime('%Y-%m-%d')
    city = data['city']
    filename = f"{current_date}_{city}.json"  # Construct the filename dynamically
    file_path = os.path.join('history', filename)
    
    # Construct a dictionary with the city name and its weather data
    weather_data = {city: data['data']}
    
    with open(file_path, 'w') as file:  # Use 'w' mode to overwrite the file each time
        json.dump(weather_data, file, indent=4)  # Use indent parameter for better formatting


        
        


if __name__ == '__main__':
    print(weather("ashkelon"))

