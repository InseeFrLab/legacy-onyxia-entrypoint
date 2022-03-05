curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g yarn
code-server --install-extension vscodevim.vim
cd /home/coder/work
echo "test2" > hello4.txt
git clone https://github.com/garronej/tss-react     && cd tss-react                   && yarn        && yarn build             && cd ..
git clone https://github.com/garronej/powerhooks    && cd powerhooks                  && yarn        && yarn build             && cd ..
git clone https://github.com/InseeFrLab/onyxia-ui   && cd onyxia-ui                   && yarn        && yarn build             && cd ..
git clone https://github.com/InseeFrLab/keycloakify && cd keycloakify                 && yarn        && yarn build             && cd ..
git clone https://github.com/garronej/evt           && cd evt && git checkout v2_beta && npm install && npm run build          && cd ..
git clone https://github.com/garronej/cra-envs      && cd cra-envs                    && yarn        && yarn build             && cd ..
git clone https://github.com/garronej/tsafe         && cd tsafe                       && yarn        && yarn build             && cd ..
git clone https://github.com/garronej/clean-redux   && cd clean-redux                 && yarn        && yarn build             && cd ..
git clone https://github.com/InseeFrLab/onyxia-web  && cd onyxia-web                  && yarn        && yarn link_inhouse_deps && cd ..
