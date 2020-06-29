#!/bin/bash
# Generates an SSH config file for connections if a config var exists.
# Technique from
# https://stackoverflow.com/questions/10869796/npm-private-git-module-on-heroku

echo "Considering injecting GIT_SSH_KEY..."

if [[ "$GIT_SSH_KEY" != "" ]]; then
    echo 'x' >> ~/git-ssh-key-injection

    if [[ "$(wc -l ~/git-ssh-key-injection | cut -d' ' -f1)" == "1" ]]; then
        echo "...detected SSH key for git. Adding SSH config."

        # Ensure we have an ssh folder
        if [ ! -d ~/.ssh ]; then
            mkdir -p ~/.ssh
            chmod 700 ~/.ssh
        fi

        # Load the private key into a file.
        echo $GIT_SSH_KEY | base64 --decode > ~/.ssh/deploy_key

        # Change the permissions on the file to
        # be read-only for this user.
        chmod 400 ~/.ssh/deploy_key
        
        if [[ -f ~/.ssh/config ]]; then
            cp ~/.ssh/config ~/.ssh/config.beforegit
        fi
        
        # Setup the ssh config file.
        echo -e "Host github.com\n"\
                " IdentityFile ~/.ssh/deploy_key\n"\
                " IdentitiesOnly yes\n"\
                " UserKnownHostsFile=/dev/null\n"\
                " StrictHostKeyChecking no"\
                > ~/.ssh/config
    else
        echo "...no GIT_SSH_KEY.  Skipping."
    fi
fi
