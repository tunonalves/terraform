# Prácticas de Terraform

Colección de ejercicios independientes de infraestructura como código: archivos locales, valores aleatorios y recursos de AWS (S3, VPC y EC2). No es un único despliegue ni un módulo listo para producción.

## Contenido

| Directorio | Qué declara el código |
| --- | --- |
| [practica1](practica1/) | Un recurso `local_file` que escribe `productos.txt`. |
| [practica2](practica2/) | Tres archivos locales con sufijos generados mediante `random_string`. |
| [practica3](practica3/) | Tres buckets S3 con nombres aleatorios y etiquetas. |
| [practica4](practica4/) | Dos VPC, en `us-east-1` y `us-east-2`, con el proveedor alternativo `aws.ohio`. |
| [practica5](practica5/) | Otra práctica de las dos VPC y las variables `virginia_cidr` y `ohio_cidr`. |
| [practica6](practica6/) | VPC, subred pública y privada, Internet Gateway, tabla de rutas pública, grupo de seguridad SSH e instancia EC2. |

Cada carpeta es un directorio de trabajo separado. Ejecutar Terraform en la raíz no reúne las configuraciones de sus subdirectorios.

## Requisitos y configuración

- En las prácticas 4, 5 y 6, `providers.tf` declara Terraform `~>1.10.5` y el proveedor `hashicorp/aws` `~>5.83.1`.
- Las prácticas 1 y 2 utilizan los proveedores `local` y/o `random`; la práctica 3 utiliza `aws` y `random`. Sus archivos no fijan versiones explícitas.
- Las prácticas con AWS requieren una cuenta de laboratorio, permisos adecuados y autenticación configurada por un mecanismo seguro del proveedor. No incorporar claves de acceso al repositorio.
- Existen archivos `terraform.tfvars` y, en las prácticas 4 y 5, `redes.auto.tfvars`. Revisar sus valores localmente antes de cualquier uso: Terraform carga automáticamente estos nombres. No copiar valores de cuentas ajenas ni publicar secretos.
- No se incluye un archivo `.terraform.lock.hcl` versionado; las dependencias no están completamente bloqueadas.

### Entradas de la práctica 6

Las declaraciones están en [variables.tf](practica6/variables.tf):

| Variable | Tipo y uso |
| --- | --- |
| `virginia_cidr` | `string`: bloque CIDR de la VPC. |
| `subnets` | `list(string)`: se utilizan los índices `0` y `1` para las subredes pública y privada. |
| `tags` | `map(string)`: el sufijo de nombres usa las claves `project`, `env` y `region`. |
| `sg_ingress_cidr` | `string`: origen autorizado para SSH, puerto 22. Restringirlo a una red controlada. |

[data.tf](practica6/data.tf) busca un par de claves existente llamado `mykey`. [ec2.tf](practica6/ec2.tf) fija una AMI y el tipo `t2.micro`; la validez de la AMI debe comprobarse en la cuenta y región elegidas.

## Revisión local sin desplegar

```bash
git clone git@github.com:tunonalves/terraform.git
cd terraform
```

Leer primero los archivos `.tf` de la práctica que interese. Con Terraform instalado, se puede comprobar el formato de archivos concretos sin inicializar proveedores ni contactar AWS:

```bash
terraform fmt -check practica1/terraform.tf
terraform fmt -check practica6/vpc.tf
```

Estos comandos solo comprueban formato: no validan credenciales, permisos, disponibilidad de recursos ni corrección funcional. Si fallan por formato, no implican por sí solos un fallo de despliegue.

## Advertencias antes de ejecutar infraestructura

- Los recursos AWS pueden generar costos. No usar una cuenta de producción para estos ejercicios ni ejecutar un plan guardado sin revisar su origen y vigencia.
- [ec2.tf](practica6/ec2.tf) incluye provisionadores `local-exec` y `remote-exec`: una ejecución puede lanzar comandos locales y comandos SSH en la instancia.
- La conexión SSH apunta a una ruta absoluta de Windows para una clave privada. Esa ruta no es portable y no garantiza que la clave corresponda al par `mykey`. No subir la clave al repositorio.
- Los comandos `local-exec` contienen `$(aws_instance-public_instance-public.IP)`, que no es interpolación de Terraform; requieren revisión antes de usarse.
- El ciclo de vida de EC2 incluye `prevent_destroy = true` e `ignore_changes` para varios atributos. Esto afecta la eliminación y las actualizaciones; no retirar esas protecciones sin entender el estado existente.
- Aunque se llama `ec2_public_ip`, la salida de [output.tf](practica6/output.tf) devuelve el objeto completo `aws_instance.public_instance`, no únicamente su IP pública.
- Hay artefactos versionados como `practica3/s3.plan`, `practica3/s3.bucket` y `.infracost/`. No son una guía de ejecución ni evidencia de que la infraestructura siga existiendo; los planes y estados pueden contener datos sensibles.

## Alcance de la verificación

Esta documentación se basa en una revisión estática de los archivos fuente, restricciones de proveedores y rutas del repositorio. No se ejecutaron `terraform init`, `plan`, `apply`, `destroy`, provisionadores ni llamadas a AWS. El formato con Terraform y el funcionamiento de las prácticas no se verificaron en ejecución.
