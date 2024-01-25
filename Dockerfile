FROM codercom/code-server:latest
SHELL ["/bin/bash" , "-c"]

# Set environment variables for the port and Git repository URL with default values
ENV CODE_SERVER_PORT=8080
ENV GIT_REPO_URL=https://github.com/streamlit/streamlit-example
USER root
RUN sudo apt-get update && sudo apt-get install -y python3.11 python3-pip python3-venv \
curl wget git unzip build-essential libssl-dev libffi-dev python3-dev libpq-dev ffmpeg

WORKDIR /

RUN git clone $GIT_REPO_URL /app

WORKDIR /app

RUN python3 -mvenv venv
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install streamlit streamlit_folium folium spacy streamlit_octostar_research \
transformer openai streamlit_scrollable_textbox ultralytics easyocr scikit-learn deepface polyglot img2vec_pytorch

RUN code-server --install-extension ms-kubernetes-tools.vscode-kubernetes-tools \
    && code-server --install-extension ms-python.python \
    && code-server --install-extension whitphx.vscode-stlite \
    && code-server --install-extension ms-python.vscode-pylance \
    && code-server --install-extension ms-toolsai.jupyter \
    && code-server --install-extension ms-toolsai.jupyter-keymap \
    && code-server --install-extension ms-toolsai.jupyter-renderers \
    && code-server --install-extension ms-toolsai.jupyter-renderers-vscode \
    && code-server --install-extension ms-toolsai.jupyter-vscode-tests \
    && code-server --install-extension GitHub.vscode-pull-request-github \

COPY settings.json /root/.local/share/code-server/User

COPY main.sh /app
RUN chmod +x /app/main.sh
ENTRYPOINT ["/app/main.sh"]

# Expose the port
EXPOSE $CODE_SERVER_PORT

# USAGE:
# docker build -t scarduzio/code-streamlit .
# docker run -e GIT_REPO_URL=https://github.com/your/repo -e CODE_SERVER_PORT=9090 -p 9090:9090 scarduzio/code-streamlit
