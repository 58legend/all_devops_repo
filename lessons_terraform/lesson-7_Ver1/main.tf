# завдання для роботи зі змінними
# - створити 5 інстансів з допомогою count
# - для імен інстансів використати масив (надам нижче)
# - надати інстансам теги і обовязково добавити ще такі 
# Owner = "created by: {{name}}" 
# Color = "favorite color is: {{color}}" 
# В результаті отримат такі теги
# Owner ="created by: Bogdan"
# Color = "favorite color is:  green"


# #для імен 
# slave = [
#     "Bodya",
#     "Vova",
#     "Maks",
#     "Dima",
#     "Sanya"
# ]
# #для тегів
# workers = {
#     Bodya: {
#         name: "Bogdan",
#         color: "green"
#     },
#     Vova: {
#         name: "Volodymyr",
#         color: "black"},
#     Maks: {
#         name: "Maksym",
#         color: "grey"},
#     Dima: {
#         name: "Dmytro",
#         color: "red"},
#     Sanya: {
#         name: "Oleksandr",
#         color: "yellow"},
# }









resource "aws_instance" "lesson-7-variables" {
  ami = var.ami_ec2 #Amazon linux
  instance_type = var.instance_type
  key_name = var.key_name
  count = length(var.server_name)
  tags = {
    # count = length(aws_instance.lesson-7-variables)
    #Name = var.server_name[count.index]
    #Owner = var.server_tag_owner[count.index]
    #Color = var.server_tag_color[count.index]
    color = "favorite color is: ${var.workers[var.server_name[count.index]].color}"
  }
}

#   count = length(aws_instance.blog)
#   target_group_arn = aws_lb_target_group.test.arn
#   target_id       = aws_instance.blog[count.index].id