# InterSystems IRIS Currency App

This InterSystems IRIS app fetches currency data from a web source and stores it in a database. Follow the instructions below to set up and run the application.

## Prerequisites

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- Python packages:
  - [Beautiful Soup (bs4)](https://pypi.org/project/beautifulsoup4/)
  - [Requests](https://pypi.org/project/requests/)

## Instructions

1. **Build and Run the Application:**

    Run the following command to build and start the Docker containers:

    ```bash
    docker-compose build && docker-compose up -d
    ```

2. **Access the IRIS Terminal:**

    Use the following command to start an IRIS session in the container:

    ```bash
    docker-compose exec iris iris session iris -U IRISAPP
    ```

3. **Fetch and Store Currency Data:**

    Run the following command to fetch currency data and store it in the database:

    ```objectscript
    write ##class(dc.sample.CurrentData).CreateRecordPython()
    ```

4. **Retrieve Record by ID:**

    To retrieve a record by ID, use the following command and pass id from previous step:

    ```objectscript
    write ##class(dc.sample.CurrentData).ReadPropertyPython(id)
    ```
4. **report csv path:**

    To view the csv output head over to container's volumes
    ```
     /home/irisowner/csv_output/
    ```
5. **Exit IRIS Session:**

    To exit the IRIS session, run:

    ```objectscript
    halt
    ```

6. **Exit Docker Terminal:**

    To exit the Docker terminal, run:

    ```bash
    exit
    ```

## Note

- Ensure that the directory mapping is correctly set up in your Docker Compose file, allowing the CSV file to be saved in the desired location.

- The currency data is fetched from the URL: [https://www.x-rates.com/table/?from=ZAR&amount=1](https://www.x-rates.com/table/?from=ZAR&amount=1)
