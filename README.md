# the-auditory-almanac

## About The Auditory Almanac

The Auditory Almanac is a web application designed to help you explore and analyze your Spotify listening history. By uploading your Spotify streaming data, you can gain insights into your music preferences over time, discover your most played tracks, and relive your musical journey.

### Running Locally

You can run The Auditory Almanac locally on your machine. This allows you to analyze your Spotify data privately and securely. Follow the instructions in the "Running the App Locally with Docker" section below to get started.

### Future Deployment

While The Auditory Almanac is currently designed for local use, I am exploring options for deploying it to a public URL in the future. This would allow users to access the application online without the need for local setup. Stay tuned for updates on this feature!

## Getting Your Spotify Streaming History

To use The Auditory Almanac, you'll need to obtain your Spotify streaming history. Here's how to do it:

1. Log in to your Spotify account on the [Spotify website](https://www.spotify.com/).

2. Go to your account page by clicking on your profile name in the top-right corner and selecting "Account" from the dropdown menu.

3. In the left sidebar, click on "Privacy settings".

4. Scroll down to the "Download your data" section and check the "Extended streaming history" box. Then check "Request data" at the bottom of the page.

5. You'll receive an email when your data is ready to download. This process can take up to 30 days, but it's usually much quicker.

6. Once you receive the email, download your data. It will be in a ZIP file.

7. Extract the ZIP file and look for JSON files with names like "StreamingHistory0.json", "StreamingHistory1.json", etc. These are the files you'll upload to The Auditory Almanac.

Note: The Auditory Almanac only processes these JSON files and does not access your Spotify account directly. Your data remains on your local machine for privacy and security.

## Running the App Locally with Docker

To run The Auditory Almanac locally using Docker, follow these steps:

1. Ensure you have Docker installed on your machine. If not, download and install it from [Docker's official website](https://www.docker.com/get-started).

2. Clone this repository to your local machine:
   ```
   git clone https://github.com/your-username/the-auditory-almanac.git
   cd the-auditory-almanac
   ```

3. Run the build script to build and run the Docker container:
   ```
   ./build_docker_dev.sh
   ```

4. Open your web browser and navigate to `http://localhost:5000` to access the application.

Note: Make sure to upload your Spotify streaming history JSON files through the application's interface once it's running.


Potential features to be added:
 - github action to deploy on push
 - add tests
 - github action to run tests on pull request
 - spotify auth to create playlists
 - use [pyscript](https://github.com/pyscript/pyscript) for visualizations?
