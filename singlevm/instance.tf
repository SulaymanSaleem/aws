resource "aws_instance" "default" {
  # ubuntu 18.04
  ami = "ami-0c30afcb7ab02233d"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.default.id}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  associate_public_ip_address = true
  key_name = "default-key-pair"
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = "${self.public_ip}"
      user = "ubuntu"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
    inline = [
      "sudo apt update",
      "sudo apt install git",
      "git clone https://github.com/Nboaram/Docker-ComposeSetup",
      "cd Docker-ComposeSetup",
      "./docker-composeInstall.sh",
      "cd",
      "git clone https://github.com/BobbyKataria/kubernetes-MEAN",
      "cd kubernetes-MEAN/api",
      "echo now running docker images...",
      "sudo docker run -d --name mongo mongo",
      "echo mongo running",
      "sudo docker build -t api .",
      "sudo docker run -d -p 8080:8080 --name api api",
      "echo ******api running******",
      "cd",
      "cd kubernetes-MEAN/ui",
      "sudo docker build -t ui .",
      "sudo docker run -d --name ui ui" 
    ]
  }
}

