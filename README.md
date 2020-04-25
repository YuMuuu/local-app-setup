# itamaeでmacの環境構築を行う
## 必要なもの
- ruby 2.4以上
## --dry-run
```bundle exec itamae local --dry-run recipes/brew.rb -y nodes/local.yml -l debug```
※必要なかったらdebugを消す
or `sh dry-run.sh`
## Provisioning
```bundle exec itamae local recipes/brew.rb -y nodes/local.yml -l```
or `sh setup.sh`
