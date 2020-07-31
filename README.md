# DNS / DHCP AWS Infrastructure

## Run locally

Initialise the repo:

```shell
  aws-vault exec moj-pttp-shared-services -- make init
```

Create your workspace

```shell
  aws-vault exec moj-pttp-shared-services -- terraform workspace new "your-user-name"
```

Select your workspace

```shell
  aws-vault exec moj-pttp-shared-services -- terraform workspace select "your-user-name"
```

Select your workspace

```shell
  aws-vault exec moj-pttp-shared-services -- terraform apply
```

## Docker images

The ISC Kea DHCP service hosted by this service runs in a Docker container.
The code for building this container can be found [here](https://github.com/ministryofjustice/staff-device-dhcp-server).

## Azure Manual Steps
N.B. This is only required for complete recreation of the Azure flow.

Due to us not having configured the Azure CLI/Terraform provider for Azure there are a number of manual steps that will need to be taken.

* You will need access to a Devl MoJ account (ask in the Slack channel for this).

* In Azure you will need to evalate your permissions using Privileged Identity Management (PIM)

* Create a three new Apps for dev, pre-prod and production using the following naming conventions:

    * staff-device-${ENV}-dhcp-azure-app

* Update the Manifest in each of the created apps with the following corresponding values per environment:

  ```
    {
      ...

    "identifierUris" : (terraform output identifierUris),

    "logoutUrl" :  (terraform output logoutUrl),
    
    "replyUrlsWithType" : [
      {    
      "url" : (terraform output url)
      "type" : "Web"
      }
    ]
    ...
    
    }
  ```
<<<<<<< HEAD
  
=======
>>>>>>> 62ba82239da4000c8f90b50bd9ee606adf3e970b
