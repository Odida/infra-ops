FROM python:3.12-slim

# Install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy the main script
COPY semver_checker.py /semver_checker.py

# Set the default command to run the script with an input argument
ENTRYPOINT ["python", "/semver_checker.py"]
