curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install python2 #Only for scss (will be removed soon)
sudo npm install -g yarn
code-server --install-extension vscodevim.vim
code-server --install-extension vscode-icons-team.vscode-icons

git clone https://github.com/garronej/working_environnement && cd working_environnement && sudo ./apply.sh && source ~/.bashrc

cd /home/coder/work
# git clone https://github.com/garronej/tss-react                && cd tss-react                   && yarn install --frozen-lockfile && yarn build    && cd ..
# git clone https://github.com/garronej/powerhooks               && cd powerhooks                  && yarn install --frozen-lockfile && yarn build    && cd ..
git clone https://github.com/InseeFrLab/onyxia-ui              && cd onyxia-ui                   && yarn install --frozen-lockfile && yarn build    && cd ..
# git clone https://github.com/InseeFrLab/keycloakify            && cd keycloakify                 && yarn install --frozen-lockfile && yarn build    && cd ..
# git clone https://github.com/garronej/evt                      && cd evt && git checkout v2_beta && npm ci                         && npm run build && cd ..
# git clone https://github.com/etalab/cra-envs                   && cd cra-envs                    && yarn install --frozen-lockfile && yarn build    && cd ..
# git clone https://github.com/garronej/tsafe                    && cd tsafe                       && yarn install --frozen-lockfile && yarn build    && cd ..
# git clone https://github.com/garronej/redux-clean-architecture && cd redux-clean-architecture    && yarn install --frozen-lockfile && yarn build    && cd ..
git clone https://github.com/InseeFrLab/onyxia-web             && cd onyxia-web                  && yarn install --frozen-lockfile                  && cd ..
