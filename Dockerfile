FROM codercom/code-server:latest
SHELL ["/bin/bash" , "-c"]

# Set environment variables for the port and Git repository URL with default values
ENV CODE_SERVER_PORT=8080
ENV GIT_REPO_URL=""
USER root
RUN sudo apt-get update && sudo apt-get install -y python3.11 python3-pip python3-venv \
curl wget git unzip build-essential libssl-dev libffi-dev python3-dev libpq-dev ffmpeg \
&& apt-get clean

# Install NVIDIA container toolkit
RUN curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list \
  && \
    apt-get update
RUN apt-get install -y nvidia-container-toolkit


WORKDIR /

RUN if [ -z "$GIT_REPO_URL" ]; then mkdir /app; else git clone $GIT_REPO_URL /app; fi

WORKDIR /app

RUN python3 -mvenv venv
RUN source venv/bin/activate
RUN source venv/bin/activate && python -m pip install --upgrade pip
RUN source venv/bin/activate && python -m pip install streamlit streamlit_folium folium spacy streamlit_octostar_research \
transformers openai streamlit_scrollable_textbox ultralytics easyocr scikit-learn deepface polyglot img2vec_pytorch

RUN code-server --install-extension ms-kubernetes-tools.vscode-kubernetes-tools \
    && code-server --install-extension ms-python.python \
    && code-server --install-extension whitphx.vscode-stlite \
    && code-server --install-extension ms-python.vscode-pylance \
    && code-server --install-extension ms-toolsai.jupyter \
    && code-server --install-extension ms-toolsai.jupyter-keymap \
    && code-server --install-extension ms-toolsai.jupyter-renderers \
    && code-server --install-extension ms-toolsai.jupyter-renderers-vscode \
    && code-server --install-extension ms-toolsai.jupyter-vscode-tests \
    && code-server --install-extension GitHub.vscode-pull-request-github

COPY init/settings.json /root/.local/share/code-server/User

RUN mkdir -p /app/init
COPY init/main.sh /app/init

RUN chmod +x /app/init/main.sh
ENTRYPOINT ["/app/init/main.sh"]

# Expose the port
EXPOSE $CODE_SERVER_PORT

# USAGE:
# docker build -t scarduzio/code-streamlit .
# docker run -e GIT_REPO_URL=https://github.com/your/repo -e CODE_SERVER_PORT=9090 -p 9090:9090 scarduzio/code-streamlit
