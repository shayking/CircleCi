from flask import Flask, request, render_template, send_file
from api_func import weather
from api_func import download_image
from api_func import upload_dynamoDB
from api_func import upload_dynamoDB_telAviv
from api_func import save_to_json
import os 
from botocore.exceptions import ClientError
import json

app = Flask(__name__)  # create object flask and assign it to application

bg_color = os.getenv('BG_COLOR', 'white')
print(bg_color)
@app.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'GET':
        return render_template('index.html', bg_color=bg_color)  # Pass bg_color to template
    try:
        if request.method == "POST":
            name = request.form.get('search')
            # dictionary with all details
            global dictionary
            dictionary = weather(name)
            save_to_json({'date': dictionary[2], 'city': name, 'data': dictionary[0]})
            print(dictionary[0])
            
            # return the index html page with the corrected details for the location
            return render_template('index.html', ret=name, dictionary=dictionary[0], method='post',
                                   country=dictionary[1], bg_color=bg_color)  # Pass bg_color to template
    except KeyError:
        return render_template('index.html', text="not succeed", bg_color=bg_color)


@app.route("/download")
def download():
    try:
        return download_image()
    except ClientError as e:
        app.logger.error(f"S3 ClientError: {e}")
        return "Internal Server Error", 500
    

@app.route("/dynamoDB")
def upload():
    try:
        dictionary_ret = dictionary[0]
        print(dictionary[2])
        upload_dynamoDB(city=dictionary[2], dictionary=dictionary_ret)
        return dictionary_ret
    
    except ClientError as e:
        app.logger.error(f"DynamoDB ClientError: {e}")
        return "Internal Server Error", 500
    

@app.route("/dynamoDB-telaviv")
def upload_telaviv():
    """
    upload tel aviv from lambda
    ###remember lambda address
    """
    try:
        return upload_dynamoDB_telAviv()
    
    except ClientError as e:
        app.logger.error(f"DynamoDB ClientError: {e}")
        return "Internal Server Error", 500
    
    
@app.route('/history')
def history():
    file_names = []
    # List all JSON files in the history directory
    for filename in os.listdir('history'):
        if filename.endswith('.json'):
            file_names.append(filename)
    return render_template('history.html', file_names=file_names, bg_color=bg_color)

@app.route('/download/<filename>')
def download_file(filename):
    file_path = os.path.join('history', filename)
    return send_file(file_path, as_attachment=True)




if __name__ == '__main__':
    app.run(debug=True, port=10000)     # start application



