# Veilid Terraform Civo

## Cost

The configuration in this repo will cost about $5/month. They don't charge for IPv4 addresses on instances, so that comes included in instance pricing.

Civo is also giving out $250 in free credits, but it expires after one month, which is a bit crap.

## Setting up access

1. Sign up for a [Civo account](https://civo.com/) if you don't already have one. You need to jump through a few hoops setting your billing details, but it's not too bad.

2. Install the [Civo CLI](https://www.civo.com/docs/overview/civo-cli#installation)

3. Get your API keys at https://dashboard.civo.com/security. Then copy the pre-existing API key (I don't know why they automatically create one for you, but you can regenerate it if you want) via running `civo apikey save` and you'll be prompted to enter it.

## Running the terraform commands

1. Add the contents of your public SSH key to the `civo_ssh_key` resource in `main.tf`. Also, make sure you do the same in `setup-veilid.yaml`.

> If you want to use a separate SSH key, then generate one in this folder like `ssh-keygen -t ed25519 -o -a 100 -f veilid-key`.

2. Decide which zone you want to run a veilid node in (the default is set to run in London). If you don't mind, then just leave it as is. If you want to run more than 1 node, change the value for `number_of_instances` in `main.tf`.

3. Run the terraform command and get a/some shiny new node(s)!

```sh
terraform apply
```

You'll see the public IP addresses to use to connect via SSH.

```sh
Outputs:

public_ip_ipv4 = [
    "159.100.248.146",
]
```

and you can connect via ssh like so:

```sh
ssh -i ROUTE_TO_PRIVATE_KEY veilid@IP_ADDRESS_FROM_OUTPUT
```

> NOTE: Since the running of the initial setup-veilid.sh script counts as part of the instance's startup, it should take about 4-5 minutes for it to be created.
