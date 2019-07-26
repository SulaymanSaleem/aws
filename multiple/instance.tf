resource "aws_instance" "mongo" {
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
      "sudo docker run -d --name mongo mongo",
      "echo mongo running" 
    ]
  }
}
resource "aws_instance" "api" {
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
      "git clone https://github.com/BobbyKataria/AWS_MEAN_DOCKER", 
      "cd AWS_MEAN_DOCKER/api",
      "sudo docker build -t api .",
      "sudo docker run -d -p 8080:8080 -e MONGO_HOST=${aws_instance.mongo.private_ip} api"
    ]
  }
}
resource "aws_instance" "ui" {
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
      "git clone https://github.com/BobbyKataria/AWS_MEAN_DOCKER",
      "cd AWS_MEAN_DOCKER/ui",
      "sudo docker build -t ui .",
      "sudo docker run -d -p 80:80 ui"
    ]
  }
}


