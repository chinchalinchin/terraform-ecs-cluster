# terraform-module-template

## Continuous Integration

The _action.yml_ _.github/workflows_ directory of your repository hooks into the **AutomationLibrary**'s _Continuous Integration_ **Terraform** workflow. This file should not need altered, but there is some additional configuration detailed below that is required for these workflows to succeed.

### Variables

If your modules contain variables without default parameters, then in order to test the release of your module in the CI pipeline, you will need to adjust the variables in _.tfvars_ to your particular project. This file is consumed in the _AutomationLibrary/.github/workflows/tf-release.yml_ during the `plan`, `apply` and `destroy` steps. See [here](https://www.terraform.io/language/values/variables#variable-definitions-tfvars-files) for more information on the configuration file. 

**NOTE**: Do not include sensitive include in the _.tfvars_ file file. Instead, if you need credentials or keys in your parameters, [add a secret](https://docs.github.com/en/actions/security-guides/encrypted-secrets) to your repository and inject it into an [environment variable](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsenv).

### Documentation

You may configure the values of _.terraform-docs.yml_ to modify documentation output for your specific project. The values in this file are used to configure `tfdocs` command in the pipeline. See [here](https://terraform-docs.io/user-guide/configuration/) for more information on the configuration file.

_.terraform-docs.yaml_ is configured to output the result of processing the **Terraform** modules' _READMEs_ into _docs/source/OVERVIEW.md_. This is so the outputted markdown files can be hooked into the **Sphinx** markdown-to-html processing. See [GH Pages](#gh-pages) below for more information.

### Security

You will can adjust the values of the  _.terraform-security.yml_ in the root of your repository for the _Terraform Scan_ workflow for your specific project. The values in this file are used to configure `tfsec` command in the pipeline. See [here](https://aquasecurity.github.io/tfsec/v1.27.6/guides/configuration/config/) for more information on the configuration file.

## GH Pages

Documentation is published to the _gh-pages_ branch of each repository. The _docs_ directory in this master repository has a preconfigured **Sphinx** project that demonstrates how the pipleine process _md_ Markdown files into _html_ webpage documents. Change directory into _docs_ and build the _html_ files,

```shell
cd docs
make html
```

HTML will be generated from the markdown in the _docs/source_ directory and processed into the _docs/build_ directory. See [Sphinx Documentation](https://www.sphinx-doc.org/en/master/usage/quickstart.htm) for more information. You can configure the project name, authors and version displayed on the documentation web page by adjusting the values in _docs/source/conf.py_.

Copy the contents of _docs_ in this repository into a _docs_ directory in your own repository and configure it for your specific project.

**NOTE**: After the pipeline has built the document the first time, you can find the URL for your documentation webpage in your _Repository_ > _Settings_ > _Pages_.

**NOTE**: You will need to initialize the _gh-pages_ branch before the pipeline can hook into it. The branch will need to be empty.

```shell
git checkout -b gh-pages
rm -rf **/*
```

You will need to add a _.gitignore_ with the following patterns ignored (also included in the _.sample.terraform-gitignore_ file),

```
/docs/build/*
**/.venv
**/.terraform
**/*.tfstate
**/*.tfstate.backup
**/.terraform.lock.hcl
**/bin/**
**/plugins/**
**/docs/build/**
**/*.zip
**/*.tar
**/*.gz
```

And then commit it and push it up to the remote,

```shell
git add . 
git commit -m 'initiailize gh-pages branch'
git push --set-upstream origin gh-pages
```


## Docs
### Github Actions
- [Reusable Workflows](https://docs.github.com/en/actions/using-workflows/reusing-workflows#using-inputs-and-secrets-in-a-reusable-workflow)
- [Managing Actions on Github Enterprise Servr (GHES)](https://docs.github.com/en/enterprise-server@3.5/admin/github-actions/managing-access-to-actions-from-githubcom/about-using-actions-in-your-enterprise)
- [Enable Debug Logging](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging)
- [Booz Allen CSN Github Actions](https://github.boozallencsn.com/actions)
### Terraform Docs
- [Configuration File](https://terraform-docs.io/user-guide/configuration/)
### Terraform Security
- [Configuration File](https://aquasecurity.github.io/tfsec/v1.27.6/guides/configuration/config/)
### Sphinx
- [Sphinx Getting Started](https://www.sphinx-doc.org/en/master/usage/quickstart.html)
- [Material for Sphinx](https://bashtage.github.io/sphinx-material/)