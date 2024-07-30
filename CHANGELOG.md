# Platform Engineering

## 0.2.0

* https://pnpm.io/installation

## 0.1.0

### 1st-Init

* `brew install make`

* `backstage`

```
npx @backstage/create-app@latest --skip-install

export GITHUB_TOKEN=your_personal_github_token

echo "Configuring to use Yarn 3.5.0 rather than 1.22.22"
corepack enable
corepack prepare yarn@3.5.0 --activate
echo "yarn version should show 3.5.0"
yarn --version

yarn install
yarn dev
```