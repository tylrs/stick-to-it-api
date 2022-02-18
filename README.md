# Stick To It API

This API was built with Ruby on Rails with a PostgreSQL database for the front-end [Stick To It](https://github.com/tylrs/stick-to-it-ui).

The API is deployed on Heroku [https://stick-to-it-api.herokuapp.com/](https://stick-to-it-api.herokuapp.com/)

Fetches can be made directly from the link above or this repo can be installed and run locally

## Badges

<p style="text-align: left;"> 
    <img alt="Ruby Badge" src="https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white" />
    <img alt="Rails Badge" src="https://img.shields.io/badge/rails-%23CC0000.svg?style=for-the-badge&logo=ruby-on-rails&logoColor=white" />
</p>

## Features

- The following endpoints are available without authorization: Log In, Create User
- Other endpoints are available with authorization (JWT received from Log In response):
  - Creating a habit including setting the date range to generate habit logs from
  - Getting all habits associated with a user including all the habit logs for the current week
  - Updating a habit log marking it as completed or not
  - Deleting a habit and all associated habit logs

## Installation

Clone the repository and install dependencies

```zsh
git clone (link from GitHub)
cd stick_to_it_api
bundle install
```

## Deployment

To run locally, `cd` into the project folder and run

```zsh
rails s
```

## Endpoints

Fetches can be made from the following endpoints:

| Purpose                                            | URL                                                      | Verb  | Request Body                                                                                                                 | Sample Response                                                                                                                                                            |
| -------------------------------------------------- | -------------------------------------------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Create Account                                     | /users                                                   | POST  | `{name: "Sample Name", username: "samplename1", email: "sample@example.com", password: "123", password_confirmation: "123"}` |                                                                                                                                                                            |
| Log In                                             | /auth/login                                              | POST  | `{email: "sample@example.com", password: "123"}`                                                                             | `{"token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2Vy", "exp": "02-18-2022 10:48", "user": {"id": 1, "name": "Sample Name", "username": "samplename1", "email": "sample@example.com"}` |
| Create a Habit                                     | /users/:user_id/habits                                   | POST  | `{name: "Habit Name", description: "Habit Description", start_datetime: "timestamp", end_datetime: "timestamp"}`             | `{id: 1, user_id: 1, name: "Habit Name", description: "Habit Description", created_at: "timestamp", updated_at: "timestamp"}`                                              |
| Update a Habit                                     | /users/:user_id/habits/:habit_id/habit_logs/habit_log_id | PATCH | N/A                                                                                                                          | `{"habit_log": {"completed_at": "timestamp", "id": 1, "habit_id": 1, "scheduled_at": "timestamp", "created_at": timestamp, "updated_at": "timestamp"}}`                    |
| Get 1 User's Habits and Current Week of Habit Logs | /users/:user_id/habits                                   | GET   | N/A                                                                                                                          | `[{"id": 1, "habit_id": 1, "scheduled_at": "timestamp", "completed_at": "timestamp"}]}]`                                                                                   |
