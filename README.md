# cisco-sso helm charts

## Add the repo to Helm.

```
helm repo add cisco-sso "https://raw.githubusercontent.com/cisco-sso/charts/master/pkg"
```

## Browse charts hosted by the repo.

```
helm search cisco-sso
```

## Install a chart from the repo.

```
helm install cisco-sso/<ChartName> --name <ReleaseName>
```

## Contribute a chart to the repo.

**NOTE:** Automation in this git repo is only supported when running in a fully updated [Kubernetes Development Kit](https://github.com/cisco-sso/k8s-devkit).

1. Add a chart to a new folder in the `src` directory.
2. In the top directory of the repository, run `awake` to package latest charts and generate an updated chart repo index.
3. Commit your changes to git.
4. Open a PR and submit it for review by assigning at least one of your write-access holding peers.
5. After your PR merges, wait a minute or two for the repo mirror to pull and publish the updated `master` branch.
6. Run `helm repo update` and try to install your newly published chart.
