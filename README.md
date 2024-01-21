# Ready to code in Kubernetes!

## Usage

You can tell the image to clone any repo, passing the `GIT_REPO_URL` env var, or bind the vscode server to any port using the `CODE_SERVER_PORT` env var. 


```
 docker run -e GIT_REPO_URL=https://github.com/your/repo -e CODE_SERVER_PORT=9090 -p 9090:9090 scarduzio/code-streamlit
```

Now, open the browser: http://<docker-host>:9090 and start coding in your IDE within a docker container, and run the streamlit app in the same container.


