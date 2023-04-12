
variable "instance_size" {
  type        = string
  description = "ec2 web server size"
  default     = "t2.micro"
}

variable "instance_ami" {
  type        = string
  description = "Server image to use"
  default     = "ami-06e46074ae430fba6"
}
variable "cidr" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly"
  type        = string
  default     = "10.0.0.0/17"

}

variable "sg" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly"
  type        = list(number)
  default     = [80, 22]
}
variable "sg_cidr" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly"
  type        = string
  default     = "0.0.0.0/0"
}
