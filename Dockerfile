FROM codercom/code-server:latest

# Set environment variables for the port and Git repository URL with default values
ENV CODE_SERVER_PORT=8080
ENV GIT_REPO_URL=https://github.com/streamlit/streamlit-example

WORKDIR /home/coder
RUN sudo apt-get update && sudo apt-get install -y python3.11 python3-pip python3-venv git 

USER coder

# Install VS Code extensions
RUN code-server --install-extension ms-kubernetes-tools.vscode-kubernetes-tools \
    && code-server --install-extension ms-python.python \
    && code-server --install-extension whitphx.vscode-stlite \
    && code-server --install-extension ms-python.vscode-pylance 

# Clone the specified Git repository
RUN git clone ${GIT_REPO_URL} /home/coder/project

RUN python3 -mvenv venv
WORKDIR /home/coder/project

# Use bash
SHELL ["/bin/bash", "-c"]
RUN source ../venv/bin/activate && pip install -r requirements.txt

# Expose the port
EXPOSE $CODE_SERVER_PORT

# Use ENTRYPOINT to start code-server on the specified or default port and with the cloned project
ENTRYPOINT ["code-server", "--bind-addr", "0.0.0.0:${CODE_SERVER_PORT}", "--auth", "none", "--disable-telemetry", "--disable-update-check", "./project"]

# USAGE:
# docker build -t scarduzio/code-streamlit .
# docker run -e GIT_REPO_URL=https://github.com/your/repo -e CODE_SERVER_PORT=9090 -p 9090:9090 scarduzio/code-streamlit