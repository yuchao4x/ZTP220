# vse-catalog
GitOps catalog of pipeline and operator resources.

## Structure
|Directory Name|Description|
|----------------|-----------------|
| `components` | This is where specific components for the GitOps Controller lives (in this case Argo CD). <br /><br /> `apps` is where operator resources YAMLs live. <br /><br /> `argocd` is where Argo CD configuration lives. This includes the ZTP Kustomize plugin. <br /><br /> `configs` is where configuration for specific use cases lives. <br /><br /> `tekton` is where Tekton YAMLs live. This includes `Pipelines`, `PipelineRuns`, `Tasks` and `Triggers` <br /><br /> Other things that can live here are RBAC, Git repo, and other Argo CD specific configurations (each in their repsective directories). |
