Backends Dart


Conexao com aws
- Apos entrar na pasta da chave de acesso executar comando no cmd
```
ssh -i "key_vakinha_dw_getx.pem" ubuntu@ec2-54-236-138-196.compute-1.amazonaws.com
```
```
sudo apt-get update
```
```
sudo apt install nginx
```
- Para atualizar os dados na nuvem
```
sudo apt-get update
```
```
cd /var/log/nginx
```
```
cd /etc/nginx/sites-enabled/
```
```
tail -f /var/log/nginx/access.log
```