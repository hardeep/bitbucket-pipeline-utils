
Docker Build/Deploy steps for Utils

Prerequisites: Docker Hub account with access to `hardeepshoker/bitbucket-pipeline-utils`

 - `docker login -u {yourusername}`
 - Enter password when propted
 - `docker build .`
 - `docker tag {imageid} hardeepshoker/bitbucket-pipeline-utils:{tagversion}`
 - `docker push hardeepshoker/bitbucket-pipeline-utils:{tagversion}`