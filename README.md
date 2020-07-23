# snyk
Loads Docker inside a Docker, for Snyk scan on Docker containers in Concourse

## Concourse Example

```
- name: snyk-docker
  plan:
  - in_parallel:
    - { get: version, trigger: true, passed: [deploy-staging] }
    - { get: src-master }
  - task: snyk-docker
    privileged: true
    config:
      platform: linux
      image_resource:
        type: docker-image
        source: {repository: hoonio/snyk}
      inputs:
        - name: src-master
        - name: version
      params:
        SNYK_TOKEN: ((snyk.token))
      run:
        path: entrypoint.sh
        args:
        - bash
        - -ceux
        - |
          docker pull $DOCKER_NAME
          snyk test --docker $DOCKER_NAME --file=./Dockerfile
          snyk monitor --docker $DOCKER_NAME --project-name=((app))-docker
```
