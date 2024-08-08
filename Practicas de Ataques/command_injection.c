#include <unistd.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
	if (argc != 2) {
		return 1;
	}
	char *cat_command = "cat ";
	char *command = argv[1];
	char *full_command = malloc(strlen(cat_command) + strlen(command) + 1);
	strcpy(full_command, cat_command);
	strcat(full_command, command);
	system(full_command);
	free(full_command);
	return 0;
}
/*
Probar introduciendo como argumento el siguiente comando:
/etc/passwd
El programa ejecutará el comando cat /etc/passwd
y mostrará el contenido del archivo /etc/passwd
Si se introduce el siguiente comando:
/etc/passwd; ls
El programa ejecutará el comando cat /etc/passwd; ls
 y mostrará el contenido del archivo /etc/passwd y el listado de archivos del directorio actual
*/


