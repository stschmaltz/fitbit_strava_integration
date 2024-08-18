```markdown
# Fitbit-Strava Integration

This Elixir Phoenix application integrates Fitbit data with Strava, allowing users to sync their Fitbit workouts to their Strava account.

## Features

- OAuth2 authentication with Fitbit
- Fetching user profile from Fitbit
- (Add other features as you implement them)

## Prerequisites

- Elixir 1.12 or later
- Phoenix 1.6 or later
- Erlang 23 or later
- PostgreSQL (if you're using a database)

## Setup

1. Clone the repository:
```

git clone https://github.com/yourusername/fitbit_strava_integration.git
cd fitbit_strava_integration

```

2. Install dependencies:
```

mix deps.get

```

3. Setup environment variables:
Create a `.env` file in the root directory with the following content:
```

FITBIT_CLIENT_ID=your_fitbit_client_id
FITBIT_CLIENT_SECRET=your_fitbit_client_secret

```

4. Start the Phoenix server:
```

mix phx.server

```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Usage

1. Visit `/api/fitbit/auth` to start the Fitbit OAuth flow
2. After authentication, you can access `/api/fitbit/profile` to see your Fitbit profile data

## API Endpoints

- `GET /api/fitbit/auth`: Initiates Fitbit OAuth flow
- `GET /api/fitbit/callback`: Handles Fitbit OAuth callback
- `GET /api/fitbit/profile`: Fetches user's Fitbit profile (requires authentication)

## Contributing

While this is a proprietary project, contributions are welcome. If you'd like to contribute, please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please note that by submitting a pull request, you agree to allow the project owner to license your work under the same license as that used by the project.

## Copyright and License

Copyright © 2024 Shane Schmaltz. All rights reserved.

This software and associated documentation files (the "Software") are the proprietary property of Shane Schmaltz and are protected by copyright law.

Permission is hereby granted to view and fork this repository for the purposes of contributing to the project or evaluating the software. However, unauthorized copying, modification, merger, publication, distribution, sublicensing, and/or selling of copies of the Software, or any portion thereof, for any purpose other than contributing to this project, is strictly prohibited without the express written permission of Shane Schmaltz.

Contributors grant Shane Schmaltz a non-exclusive, irrevocable, worldwide, royalty-free license to use, modify, and distribute their contributed work as part of this project.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

```
