Update the .env file with a strong password. Be sure to limit access to your host server on the port specified in docker-compose.yml, which is 2401 by default.

If you would like to login WITHOUT a password required to connect via SSH, then, on a Mac, create a key
# ssh-keygen -b 4096 -t rsa -f "id_rsa.pub"

Then copy that id_rsa.pub file to the build directory:

cp ~/.ssh/id_rsa.pub "./build"

Move all these files to the build server you will host this on.

docker compose build (takes 3-30 minutes, depending on internet and system speed.)

docker compose up -d

Connect to the running image (change localhost to your ip/server name):
ssh -p 2401 -o StrictHostKeyChecking=no root@localhost

Open a command line and verify that observable is installed: 
# verify observable installed
node -e "const { Runtime } = require('@observablehq/runtime'); console.log('Observable Framework installed successfully!');"

I prefer VS Code and use Remote Explorer to connect, here is an example config snippet:

Host observable-python
  HostName localhost
  Port 2401
  StrictHostKeyChecking no
  User root

Connect to the server, Trust the Author, navigate to /workspace

Set up your first observable framework project, see https://observablehq.com/framework/getting-started#1-create

