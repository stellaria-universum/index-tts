### 🚀 Quick Start with Docker

Get up and running with **IndexTTS** in just a few steps using Docker.

1. **Clone the repository**  
   This repo includes a ready-to-use Docker setup for IndexTTS:

   ```bash
   git clone -b docker https://github.com/stellaria-universum/index-tts && cd index-tts
   ```

2. **Build and launch the container**  
   Use Docker Compose to build the image and start the service in the background:

   ```bash
   docker-compose up --build
   ```

3. **Access the web interface**  
   Once the container is running, open your browser and navigate to:

   👉 [http://localhost:7860](http://localhost:7860)

4. **(Optional) Enter a development shell**  
   If you need to inspect or interact with the container environment directly:

   ```bash
   docker-compose run --rm index-tts /bin/bash
   ```

> ⚠️ **Important**: The Docker image is **over 40 GB** in size. Make sure you have enough disk space and a stable internet connection for the initial build and download.
```
