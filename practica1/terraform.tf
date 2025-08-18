resource "local_file" "productos" {
    content = "Lista de Productos para el mes proximo"
    filename = "productos.txt"
}