resource "aws_eip" "nat" {
     count  = length(var.public_subnet_ids)
     domain = "vpc"

     tags = {
       Name        = "${var.project_name}-${var.environment}-eip-${count.index + 1}"
       Environment = var.environment
       Project     = var.project_name
     }
   }

   resource "aws_nat_gateway" "main" {
     count         = length(var.public_subnet_ids)
     allocation_id = aws_eip.nat[count.index].id
     subnet_id     = var.public_subnet_ids[count.index]

     tags = {
       Name        = "${var.project_name}-${var.environment}-nat-gw-${count.index + 1}"
       Environment = var.environment
       Project     = var.project_name
     }
   }