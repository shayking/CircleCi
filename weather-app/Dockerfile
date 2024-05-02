FROM python:3.10

# Install necessary packages
# RUN apt-get update && \
#     apt-get install -y gunicorn

# Copy the application code to the container
COPY ./ /python3-final-project

# Set the working directory
WORKDIR /python3-final-project

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Set the BG_IMAGE environment variable with the path to the background image
ENV BG_COLOR=blue

# Expose the port your Flask app runs on
EXPOSE 8000

# Command to run the Flask application using Gunicorn
CMD ["gunicorn", "-w", "3", "--bind=0.0.0.0:8000", "application:app"]
