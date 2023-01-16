# FluxCD POC

This POC demonstrates the 'continuous deployment' (CD) using FluxCD,
i.e. the deployment of an artefact that was previously built and successfully tested in a 'continuous integration' (CI)
system.

FluxCD, which runs in a k8s-cluster , surveys a git repository outside of the cluster.
In regularl intevals, e.g. every 5 minutes, it will test for a drift in configuration
and attempt a reconciliation if found.

With only few preconditions this POC will be set up in an isolated environment,
increment a version number in a git repository, demonstrate a reconciliation adn torn down again.

# Usage
In [the configuration file of this POC](./set-env.sh) select either `multi-cluster` or `multi-tenancy`.
## Starten
```
git clone https://github.com/ludwigprager/Fluxcd-POC.git
./fluxcd-POC/10-deploy.sh
```
These two command will
- start a local git git-server (gitea) in docker-compose
- start a local kubernetes cluster (k3d)
- install FluxCD
- have FluxCD install the 'infrastructure' and 'apps' components, as specified in the repository (GitOps)

## Perform a Version Increment
```
./fluxcd-POC/80-deploy-new-release.sh
```
- the script in [80-deploy-new-release.sh](./80-deploy-new-release.sh) modifies the version of the podinfo container in the local git repo, commits and pushs
onto the git server.
- FluxCD detects the drift reconciles
## Tear Down
```
./fluxcd-POC/90-teardown.sh
```

# translation to english in progress :-). Perhaps try google translate just in case ...

# Konzept
## Verwendetes Konzept
- in das Kubernetescluster werden installiert
    - FluxCD: 4 controller im Namensraum 'flux-system': notification, source, kustomize, helm
    - 'infrastructure': Standardkomponenten, nicht spezifisch für das Projekt: nginx, traefik, prometheus usw.
    - 'apps': projektspezifische Fachapplikatonen, in diesem Fall 'podinfo'
- Die Fachapplikation - hier vertreten durch 'podinfo' - kommt aus einem helm-chart.
- zero footprint: es werden keine bestehenden Ressourcen beeinflußt. Die Skripte verwenden eine gesonderte 'kubeconfig'-Datei.
- der POC ist 'self contained', d.h. nicht an die LP-Umgebung gebunden
- das ['tear-down' Skript](./90-teardown.sh)  löscht alle gestarteten Ressourcen, nach dem Löschen des Ordners wäre der Zustand vor Verwendung des POC wiederhergestellt.
- die Skripte sind idempotent
- [`multi-cluster`](./set-env.sh) verwendet den 'monorepo'-Ansatz: der cluster und die Umgebungen werden in der gleichen Ablage verwaltet.

## Alternative Konzepte
Neben 'monorepo' kennt FluxCD auch Varianten mit
- einer Ablage pro cluster
- einer [Ablage pro Umgebung (environment)](https://fluxcd.io/flux/guides/repository-structure/#repo-per-environment)
- einer [Ablage pro Entwicklergruppe](https://fluxcd.io/flux/guides/repository-structure/#repo-per-team)
- einer [Ablage pro Applikation](https://fluxcd.io/flux/guides/repository-structure/#repo-per-app)
- CI im k8s-cluster. (Hier findet 'CI' außerhalb, vorher, auf den 'github-runner' statt
- 'multi-tenant' Ablagestruktur: Unterscheidung zwischen 'admin' (platform team) und Entwicklergruppe. Nur 'admin' können das cluster konfigurieren. 'dev'-personae können nur 'apps' verändern. (siehe [Referenzen](#ref))

## Erweiterungen
Hier nicht verwendet, aber von FluxCD unterstützt ist
- [pre / post-deployment jobs](https://fluxcd.io/flux/use-cases/running-jobs/)  
- secret management (Mozilla SOPS)
- messaging/alerting: Benachrichtigung bei drift/update
- automatische Synchronisierung auf eine OCI-Ablage
- Ersatz von 'helm' durch 'kustomize'
- In der FluxCD-Dokumentation finden sich etlich Beispiele für vorhergehende CI-Schritte mit github-actions: 
    - automatische MRs
    - Promotion in die Produktivumgebung
    - Komponententests mit 'kind' in der pipeline (siehe [Referenzen](#ref))

# Verschiedenes
- es wird 'gitea' als git-server verwendet, nicht die LP github Instanz. 
- anstatt 'k3d' kann auch 'minikube' verwendet werden. 'k3d' ist aber schneller, zuverlässiger und kann mehrere k8s-cluster erzeugen. Damit wären ggfs. Testszenarien möglich, die mehrere cluster voraussetzen.

# Befehle
Anweisung eines unmittelbaren Ausgleichs (reconciliation), ohne auf eine Zeitüberschreitung zu warten:

```
flux reconcile kustomization flux-system --with-source
```
Auflistung aller FluxCD-spezifischen Ressourcen, die im cluster aktiv sind:
```
kubectl get $(kubectl api-resources | grep -i flux | cut -d' ' -f1 | tr '\n' ',' | sed 's/,$//g') -A;
```
Auflistung der mittels 'kustomize' kontrollierten Komponenten:
```
./flux get all
```	


# Voraussetzungen
- Linux OS. Auf MacOS nicht getestet.
- 'docker' und 'docker-compose'

<a name="user-content-ref"></a>

# Referenzen
[kustomize helm example](https://github.com/fluxcd/flux2-kustomize-helm-example)  
[multi tenancy example](https://github.com/fluxcd/flux2-multi-tenancy)  
[Ablagestruktur](https://fluxcd.io/flux/guides/repository-structure/)  
[Helm OCI Ablage](https://fluxcd.io/flux/guides/helmreleases/#helm-oci-repository)  
[SOPS secret management](https://fluxcd.io/flux/guides/mozilla-sops/)  
[encrypt secrets](https://github.com/fluxcd/flux2-kustomize-helm-example#encrypt-kubernetes-secrets)  
[add cluster to fleet](https://github.com/fluxcd/flux2-kustomize-helm-example#add-clusters)  
[e2e test in pipeline](https://github.com/fluxcd/flux2-kustomize-helm-example/blob/main/.github/workflows/e2e.yaml)  
[FluxCD Kustomize API reference](https://fluxcd.io/flux/components/kustomize/api/)  
[FluxCD kustomization](https://fluxcd.io/flux/components/kustomize/kustomization/)
