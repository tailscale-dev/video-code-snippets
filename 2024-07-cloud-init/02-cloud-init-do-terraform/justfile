#!/usr/bin/env -S just --justfile
# ^ A shebang isn't required, but allows a justfile to be executed
#   like a script, with `./justfile test`, for example.

## terraform stuff
init:
  cd terraform && terraform init

apply:
  cd terraform && terraform apply

destroy:
  cd terraform && terraform destroy

## ansible stuff
run HOST *TAGS:
  cd ansible && ansible-playbook -b run.yaml --limit {{HOST}} {{TAGS}}

## repo stuff
# optionally use --force to force reinstall all requirements
reqs *FORCE:
  cd ansible && ansible-galaxy install -r requirements.yaml {{FORCE}}

# ansible vault (encrypt/decrypt/edit)
vault ACTION:
    cd ansible && EDITOR='code --wait' ansible-vault {{ACTION}} vars/secrets.yaml
