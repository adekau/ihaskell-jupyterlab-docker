FROM gibiansky/ihaskell

USER root

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs
RUN mkdir -p /usr/etc
RUN chown -R jovyan:jovyan /usr/etc
USER jovyan

ENV HOME=/home/jovyan

WORKDIR $HOME/ihaskell

COPY --chown=jovyan IHaskell/requirements.txt requirements.txt
COPY --chown=jovyan IHaskell/jupyterlab-ihaskell jupyterlab-ihaskell

RUN pip3 install -r requirements.txt
RUN pip3 install jupyterlab
RUN ihaskell install --stack

WORKDIR $HOME/ihaskell/jupyterlab-ihaskell

RUN npm install
RUN npm run build
RUN jupyter labextension link . --no-build
RUN NODE_OPTIONS=--max_old_space_size=4096 jupyter lab build --dev-build=False --minimize=False

RUN mkdir -p $HOME/work

WORKDIR $HOME/work

CMD ["jupyter-lab", "--ip", "0.0.0.0"]