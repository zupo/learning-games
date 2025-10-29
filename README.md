# devenv/elm-land/lamdera/ports/tailwind - DELPT

A template for starting your next [Elm](https://elm-lang.org/) project with
[elm.land](https://elm.land/), styled with [Tailwind](https://tailwindcss.com/)
and support for [JS interop](https://elm.land/guide/working-with-js) (Ports).
Fast and repeatable development and CI environment with
[devenv](https://devenv.sh/). Continuous deployment to
[Lamdera](https://lamdera.com/).

Demo: https://delpt.lamdera.app/

Inspirations:

- https://github.com/lamdera/example-apps/
- https://github.com/supermario/lamdera-realworld/
- https://github.com/kraklin/elm-land-lamdera-auth-tailwind-template

# Local develop

## Initial start

You need [devenv](https://devenv.sh/). That's it. No fiddling with JS tooling
nor containers.

```console
$ devenv up
# open http://localhost:8000
```

## Tooling

Either run `$ devenv shell` or install [direnv](https://direnv.net/) for
auto-loading of dev environment into your shell.

- Run unit tests: `tests`
- Run linters: `lint`
- Run all checks: `devenv test`
- Verify deployment: `lamdera check`
- CI: https://github.com/zupo/DELPT/actions/workflows/ci.yml
- Recommended VSCode extensions:
  - https://marketplace.visualstudio.com/items?itemName=elm-land.elm-land
    - `"elmLand.compilerFilepath": "lamdera",`
  - https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss

## Deployment

Each commit to `main` is auto-deployed to https://delpt.lamdera.app/.

Each Pull Request gets a preview app at
`https://delpt-<BRANCH_NAME>.lamdera.app/`. Like so:
https://delpt-preview-app.lamdera.app/.

To have the same in your repo, you need to set the following secrets.

#### `LAMDERA_TOKEN`

Run `lamdera login` in your terminal. Copy the token from `~/.elm/.lamdera-cli`
and save it to `https://github.com/<OWNER>/<REPO>/settings/secrets/actions` as
`LAMDERA_TOKEN`.

#### `SSH_KEY`

Run `ssh-keygen -t rsa -b 4096 -f delpt -N ""`. Copy the contents of `delpt` and
paste to `https://github.com/<OWNER>/<REPO>/settings/secrets/actions` as
`SSH_KEY`.

Copy the contents of `delpt.pub` and paste into `Add new key` on
https://dashboard.lamdera.app/account/sshkeys.
