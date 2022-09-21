# add sudo yum update -y in production setting 
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent && sudo firewall-cmd --zone=public --permanent --add-service=http && sudo firewall-cmd --reload && sudo yum install httpd -y && sudo systemctl enable httpd.service --now && echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | sudo tee /var/www/html/index.html
