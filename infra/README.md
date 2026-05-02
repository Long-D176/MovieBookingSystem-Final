# Infrastructure Directory

This folder contains infrastructure-as-code and deployment support files for the project.

## What is inside

- `terraform/` - AWS infrastructure definitions for the production environment.

## How it works

Infrastructure files define cloud resources in code so the environment can be created, updated, and reviewed consistently.

## How to use

1. Open the relevant infrastructure subfolder.
2. Review the README inside that folder for specific setup instructions.
3. Fill in the required variables and credentials before applying any changes.
4. Run the planned commands carefully to avoid recreating live resources.

## Notes

- Do not store secrets in this folder.
- Keep environment-specific values in ignored variable files.
- Review infrastructure changes before applying them.
