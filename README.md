# Iorad's helm charts

Iorad's helm charts to deploy applications to Kubernetes using Helm.


## How to use

```bash
$ helm repo add iorad https://iorad.github.io/helm-charts
$ helm install iorad/<chart-name>
```

//TODO: Use this domain (https://charts.iorad.com) instead when it's available.


## How to develop


### Fork this repo

- With the name `iorad-helm-charts`

- Clone your forked repo:

  ```bash
  $ cd ~/iorad-dev/workspace
  $ git clone git@github.com:<your_github_account>/iorad-helm-charts.git
  $ cd iorad-helm-charts
  $ git remote add upstream git@github.com:iorad/helm-charts.git # to track and sync with the upstream repo
  ````


### gh-pages deployment

- Create a branch called `gh-pages` to store the `index.yaml` file of published charts:

```bash
$ git switch --orphan gh-pages
$ git commit --allow-empty -m "initial setup"
$ git push origin gh-pages
```

- Make sure `gh-pages` works by checking your github repo's page settings


- Make sure github actions is enabled for your repository

- You should see the generated `index.yaml` file at:
https://<your_github_account>.github.io/iorad-helm-charts/index.yaml


### Update helm charts

- When any changes are made and pushed to the `main` branch, we need to update the chart's version and
it will be released and updated to the helm chart repository.

- We follow the semantic versioning, starting from `0.1.0-alpha.1` to `0.1.0-beta.x`, `0.1.0-rc.x` and
`0.1.0` and then to finally to reach `1.0.0` as the first production version.

- Whenever a helm chart reaches a major version release, create a new chart named
`chart-name-v<major_version>`, for example: `example-v1`, `example-v2`, etc to keep charts easily
updated.

