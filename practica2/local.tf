resource "local_file" "productos" {
    count = 3
    content = "Lista de Clientes"
    filename = "productos-${random_string.sufijo[count.index].id}.txt"
}
