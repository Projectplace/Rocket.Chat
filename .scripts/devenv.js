const process = require('process');
const { exec } = require('child_process');

if (process.env.RC_SRC_PATH) {
  const host_path = process.env.RC_SRC_PATH;
  console.log('Using RC_SRC_PATH for local dev env.');
  exec('docker build --file ./Dockerfile_dev --tag pp-rcchat-dev:v1 .', (err, stdout, stderr) => {
    if (err) {
      console.log('Error while building image locally...');
      console.log(err);
      return;
    } else {
      exec(`docker run -v ${host_path}:/app/bundle -it -p 3000:3000 pp-rcchat-dev:v1`, (err, stdout, stderr) => {
        if (err) {
          console.log('Error while building image locally...');
          console.log(err);
          return;
        } else {
          console.log('Image up and running...');
        }
      });
    }
  });
} else {
  console.log('Please set RC_SRC_PATH to your local directory where RocketChat is cloned.');
}
