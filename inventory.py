#!/usr/bin/env python

import json

try:
    inventory_data = {
        "_meta": {
            "hostvars": {
                # Instance IP Address:
                 {
                    "ansible_port": #Instance port,
                    "ansible_ssh_private_key_file": #Path to Private key file,
                    "ansible_user": #Ansible username
                }
            }
        },
        "webserver": {
            "hosts": #Instance IP Address
        }
    }

    print(json.dumps(inventory_data, indent=4))
except Exception as e:
    print("Error: ", str(e))