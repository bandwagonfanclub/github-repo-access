#!/bin/bash
# Technique from
# https://stackoverflow.com/questions/10869796/npm-private-git-module-on-heroku

if [ "$GIT_SSH_KEY" != "" ]; then
    echo 'x' >> ~/git-ssh-key-cleanup
    
    INJECTION_CT=$(wc -l ~/git-ssh-key-injection | cut -d' ' -f1)
    CLEANUP_CT=$(wc -l ~/git-ssh-key-cleanup | cut -d' ' -f1)
    
    if [[ "$INJECTION_CT" == "$CLEANUP_CT" ]]; then
        echo "Cleaning up SSH config"

        # Now that npm has finished running, we shouldn't need the ssh key/config
        # anymore. Remove the files that we created.
        rm -f ~/.ssh/config
        rm -f ~/.ssh/deploy_key

        if [[ -f ~/.ssh/config.beforegit ]]; then
            cp ~/.ssh/config.beforegit ~/.ssh/config
        fi

        # Clear that sensitive key data from the environment
        export GIT_SSH_KEY=0
        
        rm ~/git-ssh-key-injection
        rm ~/git-ssh-key-cleanup
    fi
fi
